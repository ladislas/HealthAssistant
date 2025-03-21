// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Alamofire
import Foundation

extension APISpringBoot: UserManagementProtocol {
    func createUser(id: String) async throws -> UserModel {
        let parameters: [String: Any] = ["id": id]

        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users", method: .post, parameters: parameters)
                    request.validate()
                        .responseDecodable(of: UserModel.self) { response in
                            switch response.result {
                                case let .success(user):
                                    continuation.resume(returning: user)
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

    func fetchUser(id: String) async throws -> UserModel? {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)", method: .get)
                    request.validate()
                        .responseDecodable(of: UserModel.self) { response in
                            switch response.result {
                                case let .success(user):
                                    continuation.resume(returning: user)
                                case let .failure(error):
                                    if let statusCode = response.response?.statusCode, statusCode == 404 {
                                        continuation.resume(returning: nil)
                                    } else {
                                        continuation.resume(throwing: self.handleError(error))
                                    }
                            }
                        }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func updateUser(_ user: UserModel) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(user.id)", method: .put, body: user)
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

    func deleteUser(id: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)", method: .delete)
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
