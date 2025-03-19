// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct HealthAssistantApp: App {
    // MARK: Internal

    var body: some Scene {
        WindowGroup {
            MainView()
                .sheet(isPresented: !self.$authManagerViewModel.isAuthenticated) {
                    LoginView()
                        .interactiveDismissDisabled()
                }
        }
        .environment(self.authManagerViewModel)
    }

    // MARK: Private

    @State private var authManagerViewModel = AuthManagerViewModel()
}
