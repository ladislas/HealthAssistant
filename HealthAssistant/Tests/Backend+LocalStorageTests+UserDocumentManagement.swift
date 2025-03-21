// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Testing

@testable import HealthAssistant

struct Backend_LocalStorageTests_UserDocumentManagement {
    @Test func test_add_user_document() async throws {
        // Given
        let userId = "user_id"
        let document = UserDocumentModel(id: "document_id", name: "Document Title", content: "Document Content")

        // When
        let expectedDocument = document
        try await LocalStorageUserDocumentManager().addDocument(document, for: userId)

        let documentList = try await LocalStorageUserDocumentManager().fetchDocuments(for: userId)

        // Then
        #expect(documentList.contains(expectedDocument))
    }

    @Test func test_delete_user_document() async throws {
        // Given
        let userId = "user_id"
        let document = UserDocumentModel(id: "document_id", name: "Document Title", content: "Document Content")

        // When
        do {
            try await LocalStorageUserDocumentManager().addDocument(document, for: userId)
            let documentList = try await LocalStorageUserDocumentManager().fetchDocuments(for: userId)

            #expect(documentList.contains(document))
        }

        try await LocalStorageUserDocumentManager().deleteDocument(documentId: document.id, for: userId)
        let documentList = try await LocalStorageUserDocumentManager().fetchDocuments(for: userId)

        // Then
        #expect(!documentList.contains(document))
    }

    @Test func test_delete_all_documents() async throws {
        // Given
        let userId = "user_id"
        let document = UserDocumentModel(id: "document_id", name: "Document Title", content: "Document Content")

        // When
        try await LocalStorageUserDocumentManager().addDocument(document, for: userId)
        try await LocalStorageUserDocumentManager().deleteAllDocuments(for: userId)

        do {
            let documentList = try await LocalStorageUserDocumentManager().fetchDocuments(for: userId)
            #expect(documentList.isEmpty)
        }

        let documentList = try await LocalStorageUserDocumentManager().fetchDocuments(for: userId)

        // Then
        #expect(documentList.isEmpty)
    }

    @Test func test_rename_document() async throws {
        // Given
        let userId = "user_id"
        let originalDocumentId = "original_document_id"
        let originalDocumentName = "Original Document Name"
        let renamedDocumentName = "Renamed Document Name"

        let originalDocument = UserDocumentModel(id: originalDocumentId, name: originalDocumentName, content: "")

        try await LocalStorageUserDocumentManager().addDocument(originalDocument, for: userId)

        // When
        try await LocalStorageUserDocumentManager().renameDocument(documentId: originalDocumentId, newName: renamedDocumentName, for: userId)

        // Then
        let documentList = try await LocalStorageUserDocumentManager().fetchDocuments(for: userId)
        let renamedDocument = try #require(documentList.first { $0.id == originalDocumentId })

        #expect(renamedDocument.name == renamedDocumentName)
    }
}
