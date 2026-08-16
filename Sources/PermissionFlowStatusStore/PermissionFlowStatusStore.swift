#if os(macOS)
import AppKit
import Combine
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
@MainActor
public final class PermissionFlowStatusStore: ObservableObject {
    @Published public private(set) var states: [PermissionFlowPane: PermissionAuthorizationState]

    private var trackedPanes: [PermissionFlowPane]
    private var didBecomeActiveCancellable: AnyCancellable?

    public init(
        panes: [PermissionFlowPane] = PermissionFlowPane.allCases,
        refreshOnAppActivation: Bool = true
    ) {
        self.trackedPanes = panes
        // Assign the real snapshot once. A second @Published write in init
        // (or a Task { @MainActor in } hop) can fire during @StateObject setup.
        self.states = Self.authorizationStates(for: panes)

        if refreshOnAppActivation {
            didBecomeActiveCancellable = NotificationCenter.default
                .publisher(for: NSApplication.didBecomeActiveNotification)
                .sink { [weak self] _ in
                    // Combine delivers on the posting thread, not the MainActor
                    // executor. Hop first, then leave the current view-update turn.
                    Task { @MainActor [weak self] in
                        await self?.refreshAfterCurrentUpdate()
                    }
                }
        }
    }

    public func state(for pane: PermissionFlowPane) -> PermissionAuthorizationState {
        states[pane] ?? PermissionStatusRegistry.provider(for: pane).authorizationState()
    }

    public func capability(for pane: PermissionFlowPane) -> PermissionStatusCapability {
        PermissionStatusRegistry.provider(for: pane).capability
    }

    public func refresh() {
        apply(Self.authorizationStates(for: trackedPanes))
    }

    public func refresh(_ pane: PermissionFlowPane) {
        apply([pane: Self.authorizationState(for: pane)])
    }

    public func track(_ panes: [PermissionFlowPane], refreshImmediately: Bool = true) {
        trackedPanes = panes

        if refreshImmediately {
            refresh()
            return
        }

        var seed: [PermissionFlowPane: PermissionAuthorizationState] = [:]
        for pane in panes where states[pane] == nil {
            seed[pane] = .checking
        }
        apply(seed)
    }

    /// Waits one main-queue turn so `@Published` does not fire mid-render.
    /// `DispatchQueue.main` is not the MainActor executor, so do not
    /// `assumeIsolated` in that callback — it can drop the refresh.
    private func refreshAfterCurrentUpdate() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            DispatchQueue.main.async {
                continuation.resume()
            }
        }
        refresh()
    }

    private func apply(_ updates: [PermissionFlowPane: PermissionAuthorizationState]) {
        guard !updates.isEmpty else { return }

        var next = states
        var changed = false
        for (pane, state) in updates {
            guard next[pane] != state else { continue }
            next[pane] = state
            changed = true
        }
        if changed {
            states = next
        }
    }

    private static func authorizationState(for pane: PermissionFlowPane) -> PermissionAuthorizationState {
        PermissionStatusRegistry.provider(for: pane).authorizationState()
    }

    private static func authorizationStates(
        for panes: [PermissionFlowPane]
    ) -> [PermissionFlowPane: PermissionAuthorizationState] {
        Dictionary(uniqueKeysWithValues: panes.map { ($0, authorizationState(for: $0)) })
    }
}
#endif
