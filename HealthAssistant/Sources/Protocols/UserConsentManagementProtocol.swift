// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol UserConsentManagementProtocol {
    func hasUserGivenConsent(id: String) async throws -> Bool
    func giveUserConsent(id: String) async throws
    func revokeUserConsent(id: String) async throws
}
