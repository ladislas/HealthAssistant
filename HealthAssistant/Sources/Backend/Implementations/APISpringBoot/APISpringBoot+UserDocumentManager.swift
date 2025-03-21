// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Alamofire
import Foundation

extension APISpringBoot: UserDocumentManagementProtocol {
    func fetchDocuments(for id: String) async throws -> [UserDocumentModel] {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/documents", method: .get)
                    request.validate()
                        .responseDecodable(of: [UserDocumentModel].self) { response in
                            switch response.result {
                                case let .success(documents):
                                    continuation.resume(returning: documents)
                                case let .failure(error):
                                    continuation.resume(throwing: self.handleError(error))
                            }
                        }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func addDocument(_ document: UserDocumentModel, for id: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/documents", method: .post, body: document)
                    request.validate()
                        .response { response in
                            switch response.result {
                                case .success:
                                    continuation.resume()
                                case let .failure(error):
                                    continuation.resume(throwing: self.handleError(error))
                            }
                        }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func deleteDocument(documentId: String, for id: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/documents/\(documentId)", method: .delete)
                    request.validate()
                        .response { response in
                            switch response.result {
                                case .success:
                                    continuation.resume()
                                case let .failure(error):
                                    continuation.resume(throwing: self.handleError(error))
                            }
                        }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func renameDocument(documentId: String, newName: String, for id: String) async throws {
        let parameters: [String: Any] = ["name": newName]

        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/documents/\(documentId)/rename", method: .patch, parameters: parameters)
                    request.validate()
                        .response { response in
                            switch response.result {
                                case .success:
                                    continuation.resume()
                                case let .failure(error):
                                    continuation.resume(throwing: self.handleError(error))
                            }
                        }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func deleteAllDocuments(for id: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/documents", method: .delete)
                    request.validate()
                        .response { response in
                            switch response.result {
                                case .success:
                                    continuation.resume()
                                case let .failure(error):
                                    continuation.resume(throwing: self.handleError(error))
                            }
                        }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
