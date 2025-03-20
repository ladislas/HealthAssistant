// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class LocalStorageUserDocumentManagerModel: UserDocumentManagementProtocol {
    // MARK: Internal

    func addDocument(_ document: UserDocumentModel, for uid: String) async throws {
        var docs = try readDocuments(for: uid)
        docs.append(document)
        try self.writeDocuments(docs, for: uid)
    }

    func fetchDocuments(for uid: String) async throws -> [UserDocumentModel] {
        try self.readDocuments(for: uid)
    }

    func deleteDocument(documentId: String, for uid: String) async throws {
        var docs = try readDocuments(for: uid)
        docs.removeAll { $0.id == documentId }
        try self.writeDocuments(docs, for: uid)
    }

    func renameDocument(documentId: String, newName: String, for uid: String) async throws {
        var docs = try readDocuments(for: uid)
        guard let index = docs.firstIndex(where: { $0.id == documentId }) else { return }
        docs[index].name = newName
        try self.writeDocuments(docs, for: uid)
    }

    func deleteAllDocuments(for uid: String) async throws {
        try self.writeDocuments([], for: uid)
    }

    // MARK: Private

    private func documentsFileURL(for uid: String) throws -> URL {
        try LocalStorage.directory(for: uid).appendingPathComponent("documents.json")
    }

    private func readDocuments(for uid: String) throws -> [UserDocumentModel] {
        let fileURL = try documentsFileURL(for: uid)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([UserDocumentModel].self, from: data)
    }

    private func writeDocuments(_ docs: [UserDocumentModel], for uid: String) throws {
        let data = try JSONEncoder().encode(docs)
        try data.write(to: self.documentsFileURL(for: uid))
    }
}
