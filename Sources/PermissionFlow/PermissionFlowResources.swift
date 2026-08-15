import Foundation

/// Public access to the package resource bundle with packaged-app fallbacks.
///
/// SwiftPM's generated `Bundle.module` can assert (and crash the host app) when
/// the resource path does not match its compile-time assumptions. Callers
/// should prefer this type — or `PermissionFlowLocalizer` — instead of
/// reading `Bundle.module` from UI or runtime code.
public enum PermissionFlowResources {
    /// SPM resource bundle name for the `PermissionFlow` target.
    public static let resourceBundleName = "PermissionFlow_PermissionFlow"

    /// Best-effort package resource bundle.
    ///
    /// Returns `nil` when the packaged resource cannot be located so callers
    /// can degrade gracefully (for example, fall back to English defaults)
    /// instead of trapping on `Bundle.module`.
    public static var packageBundle: Bundle? { resolvedPackageBundle }

    /// Resource bundle for consumers that need a non-optional `Bundle`.
    ///
    /// Prefer `packageBundle` when you can handle a missing resource bundle.
    /// This property falls back to `Bundle.main` only after package lookup
    /// fails so public API remains non-crashing in installed apps.
    public static var bundle: Bundle { packageBundle ?? .main }

    /// Localization key for the Accessibility privacy page title on
    /// macOS versions before 27.
    public static let accessibilityNameKey = "permission_flow.pane.accessibility"

    /// Localization key for the Accessibility privacy page title on
    /// macOS 27 and later, where System Settings labels the page
    /// "Device Control and Data Access".
    public static let deviceControlAndDataAccessNameKey = "permission_flow.pane.device_control_and_data_access"

    /// Localization key for the System Settings Accessibility page name.
    ///
    /// Returns `deviceControlAndDataAccessNameKey` on macOS 27 and later,
    /// and `accessibilityNameKey` on earlier versions. The settings URL
    /// and `Privacy_Accessibility` anchor are unchanged.
    public static func accessibilityName(
        operatingSystemVersion: OperatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion
    ) -> String {
        if operatingSystemVersion.majorVersion >= 27 {
            return deviceControlAndDataAccessNameKey
        }
        return accessibilityNameKey
    }

#if os(macOS)
    /// Localized System Settings label for the Accessibility privacy page.
    ///
    /// Use this in host UI when you only need to show the current page name:
    /// "Device Control and Data Access" on macOS 27+, "Accessibility" earlier.
    ///
    /// ```swift
    /// Text(PermissionFlowResources.localizedAccessibilityName())
    /// Text(PermissionFlowResources.localizedAccessibilityName(localeIdentifier: locale.identifier))
    /// ```
    @available(macOS 13.0, *)
    public static func localizedAccessibilityName(
        localeIdentifier: String? = nil,
        operatingSystemVersion: OperatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion
    ) -> String {
        let nameKey = accessibilityName(operatingSystemVersion: operatingSystemVersion)
        let defaultValue = nameKey == deviceControlAndDataAccessNameKey
            ? "Device Control and Data Access"
            : "Accessibility"
        return PermissionFlowLocalizer.string(
            nameKey,
            defaultValue: defaultValue,
            localeIdentifier: localeIdentifier
        )
    }
#endif

    private static let resolvedPackageBundle: Bundle? = findPackageResourceBundle()

    private static func findPackageResourceBundle() -> Bundle? {
        let bundleFileName = "\(resourceBundleName).bundle"

        var candidateDirectories: [URL] = []
        let marker = Bundle(for: PermissionFlowResourceBundleToken.self)

        candidateDirectories.append(contentsOf: [
            Bundle.main.resourceURL,
            Bundle.main.bundleURL,
            marker.resourceURL,
            marker.bundleURL,
            marker.bundleURL.appendingPathComponent("Contents/Resources"),
            marker.bundleURL.appendingPathComponent("Resources"),
            Bundle.main.bundleURL.appendingPathComponent("Contents/Resources"),
            Bundle.main.bundleURL.deletingLastPathComponent()
        ].compactMap { $0 })

        // De-duplicate while preserving order.
        var seen = Set<String>()
        candidateDirectories = candidateDirectories.filter { url in
            seen.insert(url.standardizedFileURL.path).inserted
        }

        for directory in candidateDirectories {
            let directURL = directory.appendingPathComponent(bundleFileName)
            if let bundle = Bundle(url: directURL) {
                return bundle
            }

            let nestedURL = directory
                .appendingPathComponent("Contents")
                .appendingPathComponent("Resources")
                .appendingPathComponent(bundleFileName)
            if let bundle = Bundle(url: nestedURL) {
                return bundle
            }
        }

        // Scan already-loaded bundles/frameworks for the packaged resource.
        for host in Bundle.allBundles + Bundle.allFrameworks {
            if host.bundleURL.lastPathComponent == bundleFileName {
                return host
            }
            if let url = host.url(forResource: resourceBundleName, withExtension: "bundle"),
               let bundle = Bundle(url: url) {
                return bundle
            }
        }

        return nil
    }
}

/// Marker type used only for `Bundle(for:)` resolution. Must stay in this
/// module so the returned bundle points at PermissionFlow's binary/product.
private final class PermissionFlowResourceBundleToken {}
