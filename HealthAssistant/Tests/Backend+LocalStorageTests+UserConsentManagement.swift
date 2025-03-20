// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Testing

@testable import HealthAssistant

struct Backend_LocalStorageTests_UserConsentManagement {
    @Test func test_consent_initial_status() async throws {
        // Given
        let userId = "user_id"

        // When
        let hasGivenConsent = try await LocalStorageUserConsentManager().hasUserGivenConsent(id: userId)

        // Then
        #expect(hasGivenConsent == false)
    }

    @Test func test_consent_given() async throws {
        // Given
        let userId = "user_id"

        // When
        try await LocalStorageUserConsentManager().giveUserConsent(id: userId)

        // Then
        let hasGivenConsent = try await LocalStorageUserConsentManager().hasUserGivenConsent(id: userId)
        #expect(hasGivenConsent == true)
    }

    @Test func test_consent_revoked() async throws {
        // Given
        let userId = "user_id"
        try await LocalStorageUserConsentManager().giveUserConsent(id: userId)

        do {
            let hasGivenConsent = try await LocalStorageUserConsentManager().hasUserGivenConsent(id: userId)
            #expect(hasGivenConsent == true)
        }

        // When
        try await LocalStorageUserConsentManager().revokeUserConsent(id: userId)

        // Then
        let hasGivenConsent = try await LocalStorageUserConsentManager().hasUserGivenConsent(id: userId)
        #expect(hasGivenConsent == false)
    }
}
