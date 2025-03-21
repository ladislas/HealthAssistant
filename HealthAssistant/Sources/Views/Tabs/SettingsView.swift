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
                        if self.authManager.isAuthenticated {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }

                    LabeledContent("Email", value: self.authManager.email)

                    LabeledContent("UID") {
                        Text(self.authManager.uid)
                            .monospaced()
                    }
                }

                Section {
                    Button {
                        self.authManager.signOut()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                    }

                    Button(role: .destructive) {
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

    @Environment(AuthManager.self) private var authManager
}

#Preview {
    @Previewable var authManager = AuthManager.mock

    TabView {
        Tab("Settings", systemImage: "gear") {
            NavigationStack {
                SettingsView()
            }
        }
    }
    .environment(authManager)
}
