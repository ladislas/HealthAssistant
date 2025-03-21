// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct HealthAssistantApp: App {
    // MARK: Internal

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .sheet(isPresented: !self.$authManager.isAuthenticated) {
                    LoginView()
                        .interactiveDismissDisabled()
                }
        }
        .environment(self.authManager)
    }

    // MARK: Private

    @State private var authManager = AuthManager()
}
