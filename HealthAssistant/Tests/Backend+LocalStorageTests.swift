// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Testing

@testable import HealthAssistant

struct Backend_LocalStorageTests {
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

    @Test func test_create_user() async throws {
        // Given
        let userId = "user_id"
        let userName = "John Doe"
        let now = Date.now

        // When
        let expectedUser = UserModel(id: userId, displayName: userName, createdAt: now)
        let actualUser = try await LocalStorageUserManager().createUser(id: userId, displayName: userName)

        // Then
        #expect(actualUser == expectedUser)
    }

    @Test func test_create_user_throws() async {
        // Given
        let userId = ""
        let userName = "John Doe"

        // Then
        await #expect(throws: (any Error).self) {
            _ = try await LocalStorageUserManager().createUser(id: userId, displayName: userName)
        }
    }

    @Test func create_then_fetch_user() async throws {
        // Given
        let userId = "user_id"
        let userName = "John Doe"

        // When
        let expectedUser = try await LocalStorageUserManager().createUser(id: userId, displayName: userName)
        let actualUser = try await LocalStorageUserManager().fetchUser(id: userId)

        // Then
        #expect(actualUser == expectedUser)
    }

    @Test func create_then_update_user() async throws {
        // Given
        let userId = "user_id"
        let userName = "John Doe"
        let updatedUserName = "Jane Doe"

        // When
        var expectedUser = try #require(await LocalStorageUserManager().createUser(id: userId, displayName: userName))

        expectedUser.displayName = updatedUserName

        try await LocalStorageUserManager().updateUser(expectedUser)

        // Then
        let updatedUser = try await LocalStorageUserManager().fetchUser(id: userId)
        #expect(expectedUser == updatedUser)
    }

    @Test func delete_user() async throws {
        // Given
        let userId = "user_id"
        let userName = "John Doe"

        // When
        _ = try await LocalStorageUserManager().createUser(id: userId, displayName: userName)

        try await LocalStorageUserManager().deleteUser(id: userId)

        // Then
        let user = try await LocalStorageUserManager().fetchUser(id: userId)
        #expect(user == nil)
    }
}
