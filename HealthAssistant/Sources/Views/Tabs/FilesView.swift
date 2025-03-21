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
                            do {
                                try await self.consentManager.giveUserConsent(id: self.authManager.uid)
                                if try await self.consentManager.hasUserGivenConsent(id: self.authManager.uid) {
                                    print("User has given consent")
                                    self.askForConsent = false
                                }
                            } catch {
                                print("Error giving consent: \(error)")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                VStack(spacing: 20) {
                    Button {
                        self.isFilePickerPresented = true
                    } label: {
                        Label("Upload File", systemImage: "arrow.up.doc")
                            .font(.title)
                    }

                    if !self.uploadedDocuments.isEmpty {
                        List(self.uploadedDocuments) { document in
                            VStack(alignment: .leading) {
                                Text(document.name)
                                    .font(.headline)
                                Text("Created: \(document.createdAt)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Files")
        .onAppear {
            Task {
                do {
                    let consentGiven = try await self.consentManager.hasUserGivenConsent(id: self.authManager.uid)
                    self.askForConsent = !consentGiven
                    if consentGiven {
                        try await self.loadFiles()
                    }
                } catch {
                    print("Error checking consent: \(error)")
                }
            }
        }
        .fileImporter(
            isPresented: self.$isFilePickerPresented,
            allowedContentTypes: [.pdf, .image, .text],
            allowsMultipleSelection: false
        ) { result in
            switch result {
                case let .success(files):
                    guard let file = files.first else { return }
                    Task {
                        do {
                            try await self.uploadFile(file)
                        } catch {
                            print("Error uploading file: \(error)")
                        }
                    }
                case let .failure(error):
                    print("Error selecting file: \(error)")
            }
        }
    }

    // MARK: Private

    @State private var askForConsent = true
    @State private var isFilePickerPresented = false
    @State private var uploadedDocuments: [UserDocumentModel] = []
    @State private var consentManager = APISpringBoot(baseURL: "https://api.acme.com")
    @State private var documentManager = APISpringBoot(baseURL: "https://api.acme.com")

    @Environment(AuthManager.self) var authManager: AuthManager

    private func loadFiles() async throws {
        let files = try await self.documentManager.fetchDocuments(for: self.authManager.uid)
        self.uploadedDocuments = files
    }

    private func uploadFile(_ file: URL) async throws {
        let document = UserDocumentModel(name: file.absoluteString, content: "lorem ipsum")

        try await self.documentManager.addDocument(document, for: self.authManager.uid)

        self.uploadedDocuments.append(document)
    }
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
