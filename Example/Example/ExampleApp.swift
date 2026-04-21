//
//  ExampleApp.swift
//  Example
//
//  Created by wong on 4/17/26.
//

import SwiftUI
#if os(macOS)
import PermissionFlowExtendedStatus
#endif

@main
struct ExampleApp: App {
//    init() {
//#if os(macOS)
//        PermissionFlowExtendedStatus.register()
//#endif
//    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
