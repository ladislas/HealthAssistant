// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Alamofire
import Foundation

extension APISpringBoot: UserConsentManagementProtocol {
    func hasUserGivenConsent(id: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/consent", method: .get)
                    request.validate()
                        .responseDecodable(of: Bool.self) { response in
                            switch response.result {
                                case let .success(hasConsent):
                                    continuation.resume(returning: hasConsent)
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

    func giveUserConsent(id: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/consent", method: .post)
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

    func revokeUserConsent(id: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let request = try await self.createAuthenticatedRequest("\(baseURL)/users/\(id)/consent", method: .delete)
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
