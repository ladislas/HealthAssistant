// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - MainViewTabs

enum MainViewTabs: Hashable {
    case files
    case settings
}

// MARK: - MainViewViewModel

@Observable
class MainViewViewModel {
    var selectedTab: MainViewTabs = .files
}
