// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FilesView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            if self.askForConsent {
                VStack(spacing: 50) {
                    Text("Your consent is required\nto upload and view files")
                        .font(.callout)
                        .bold()
                        .multilineTextAlignment(.center)

                    Button("Give Consent") {
                        Task {
                            try await self.consentManager.giveUserConsent(id: self.authManager.uid)
                            if try await self.consentManager.hasUserGivenConsent(id: self.authManager.uid) {
                                print("User has given consent")
                                self.askForConsent = false
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Button {
                    print("Upload file")
                } label: {
                    Label("Upload File", systemImage: "arrow.up.doc")
                        .font(.title)
                }
            }
        }
        .navigationTitle("Files")
        .onAppear {
            Task {
                let consentGiven = try await self.consentManager.hasUserGivenConsent(id: self.authManager.uid)

                if consentGiven {
                    print("User has given consent")
                } else {
                    print("User has not given consent")
                }
            }
        }
    }

    // MARK: Private

    @State private var askForConsent = true
    @State private var consentManager = LocalStorageUserConsentManager()

    @Environment(AuthManager.self) var authManager: AuthManager
}

#Preview {
    @Previewable var authManager = AuthManager.mock

    TabView {
        Tab("Files", systemImage: "doc") {
            NavigationStack {
                FilesView()
            }
        }
    }
    .environment(authManager)
}
