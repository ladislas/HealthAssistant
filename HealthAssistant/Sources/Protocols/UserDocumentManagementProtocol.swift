// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol UserDocumentManagementProtocol {
    func fetchDocuments(for id: String) async throws -> [UserDocumentModel]
    func addDocument(_ document: UserDocumentModel, for id: String) async throws
    func deleteDocument(documentId: String, for id: String) async throws
    func renameDocument(documentId: String, newName: String, for id: String) async throws
    func deleteAllDocuments(for id: String) async throws
}
