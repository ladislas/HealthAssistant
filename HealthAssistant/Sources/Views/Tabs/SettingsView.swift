// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SettingsView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            List {
                Section(header: Text("General")) {
                    LabeledContent("Connected") {
                        if self.authManagerViewModel.isAuthenticated {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }

                    LabeledContent("Email", value: "john.doe@acme.com")
                }

                Section {
                    Button {
                        self.authManagerViewModel.isAuthenticated = false
                        // TODO: (@ladislas) logout
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                    }

                    Button(role: .destructive) {
                        self.authManagerViewModel.isAuthenticated = false
                        // TODO: (@ladislas) delete account
                    } label: {
                        Label("Delete Account", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }

    // MARK: Private

    @Environment(AuthManagerViewModel.self) private var authManagerViewModel
}

#Preview {
    @Previewable var authManagerViewModel = AuthManagerViewModel()

    SettingsView()
        .environment(authManagerViewModel)
}
