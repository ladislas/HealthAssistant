// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Alamofire
import FirebaseAuth
import Foundation

// MARK: - APISpringBoot

class APISpringBoot: RequestRetrier, RequestInterceptor {
    // MARK: Lifecycle

    init(baseURL: String) {
        self.baseURL = baseURL

        // Configure Alamofire session
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 300

        // Create custom session with configuration
        self.session = Session(configuration: configuration)
    }

    // MARK: Internal

    let baseURL: String

    // Helper method to get the current Firebase ID token
    func getAuthToken() async throws -> String {
        guard let currentUser = Auth.auth().currentUser else {
            throw APIError.unauthorized
        }

        return try await currentUser.getIDToken()
    }

    // Helper method to create authenticated request headers
    func createAuthHeaders() async throws -> HTTPHeaders {
        let token = try await getAuthToken()
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
    }

    // Helper method to create authenticated request
    func createAuthenticatedRequest(_ url: URLConvertible, method: HTTPMethod, body: some Encodable) async throws -> DataRequest {
        let headers = try await createAuthHeaders()
        return self.session.request(url, method: method, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
    }

    // Overload for dictionary parameters
    func createAuthenticatedRequest(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil) async throws -> DataRequest {
        let headers = try await createAuthHeaders()
        return self.session.request(url, method: method, parameters: parameters, headers: headers)
            .validate()
    }

    // MARK: - RequestRetrier

    func retry(_ request: Request, for _: Session, dueTo _: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.response else {
            completion(.doNotRetry)
            return
        }

        // Only retry on 401 (Unauthorized) to refresh token
        if response.statusCode == 401 {
            Task {
                do {
                    // Force token refresh
                    _ = try await self.getAuthToken()
                    // Update request headers with new token
                    let newHeaders = try await self.createAuthHeaders()

                    // Create a new request with the updated headers
                    if let dataRequest = request as? DataRequest {
                        var newRequest = dataRequest.request
                        newRequest?.allHTTPHeaderFields = newHeaders.dictionary
                        completion(.retry)
                    } else {
                        completion(.doNotRetry)
                    }
                } catch {
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    // Helper method to handle common error cases
    func handleError(_ error: AFError) -> Error {
        switch error {
            case let .responseValidationFailed(reason):
                switch reason {
                    case let .unacceptableStatusCode(code):
                        switch code {
                            case 401:
                                APIError.unauthorized
                            case 403:
                                APIError.forbidden
                            case 404:
                                APIError.notFound
                            case 500:
                                APIError.serverError
                            default:
                                APIError.unknown
                        }
                    default:
                        APIError.unknown
                }
            case .responseSerializationFailed:
                APIError.invalidResponse
            default:
                APIError.unknown
        }
    }

    // MARK: Private

    private let session: Session
}

// MARK: - APIError

// Custom error types for API
enum APIError: LocalizedError {
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case invalidResponse
    case unknown

    // MARK: Internal

    var errorDescription: String? {
        switch self {
            case .unauthorized:
                "Unauthorized access"
            case .forbidden:
                "Access forbidden"
            case .notFound:
                "Resource not found"
            case .serverError:
                "Server error occurred"
            case .invalidResponse:
                "Invalid response from server"
            case .unknown:
                "An unknown error occurred"
        }
    }
}

// MARK: - AFError Extension

extension AFError {
    var isNetworkError: Bool {
        switch self {
            case let .sessionTaskFailed(error as URLError):
                error.code == .notConnectedToInternet ||
                    error.code == .networkConnectionLost ||
                    error.code == .timedOut
            default:
                false
        }
    }
}
