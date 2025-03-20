// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Testing

@testable import HealthAssistant

struct Backend_LocalStorageTests_Helpers {
    @Test func test_helper_directory() async throws {
        // Given
        let userId = "user_id"

        // When
        let url = try LocalStorage.directory(for: userId)

        // Then
        #expect(url.absoluteString.hasSuffix("MockUsers/user_id/"))
    }

    @Test func test_helper_directory_throws() async {
        // Given
        let userId = ""

        // Then
        #expect(throws: (any Error).self) {
            _ = try LocalStorage.directory(for: userId)
        }
    }
}
