// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Testing

@testable import HealthAssistant

struct Backend_LocalStorageTests_UserManagement {
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
        var userToUpdate = try #require(await LocalStorageUserManager().createUser(id: userId, displayName: userName))

        userToUpdate.displayName = updatedUserName

        try await LocalStorageUserManager().updateUser(userToUpdate)

        // Then
        let updatedUser = try #require(await LocalStorageUserManager().fetchUser(id: userId))

        #expect(userToUpdate == updatedUser)
        #expect(userToUpdate.updatedAt < updatedUser.updatedAt)
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
