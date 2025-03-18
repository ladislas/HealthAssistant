// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - MainViewTabs

enum MainViewTabs: Hashable {
    case files
    case profile
}

// MARK: - MainViewViewModel

@Observable
class MainViewViewModel {
    var selectedTab: MainViewTabs = .files
}

// MARK: - MainView

public struct MainView: View {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public var body: some View {
        TabView(selection: self.$viewModel.selectedTab) {
            Tab("Files", systemImage: "doc", value: .files) {
                FilesView()
            }

            Tab("Profile", systemImage: "person.crop.circle.fill", value: .profile) {
                ProfileView()
            }
        }
    }

    // MARK: Private

    @State private var viewModel = MainViewViewModel()
}

#Preview {
    MainView()
}
