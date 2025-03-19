// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - MainView

public struct MainView: View {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public var body: some View {
        TabView(selection: self.$viewModel.selectedTab) {
            Tab("Files", systemImage: "doc", value: .files) {
                NavigationStack {
                    FilesView()
                }
            }

            Tab("Settings", systemImage: "gear", value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }

    // MARK: Private

    @State private var viewModel = MainViewViewModel()
}

#Preview {
    @Previewable var authManagerViewModel = AuthManagerViewModel()

    MainView()
        .environment(authManagerViewModel)
}
