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

        let now = Date.now

        // When
        let expectedUser = UserModel(id: userId, createdAt: now)
        let actualUser = try await LocalStorageUserManager().createUser(id: userId)

        // Then
        #expect(actualUser == expectedUser)
    }

    @Test func test_create_user_throws() async {
        // Given
        let userId = ""

        // Then
        await #expect(throws: (any Error).self) {
            _ = try await LocalStorageUserManager().createUser(id: userId)
        }
    }

    @Test func create_then_fetch_user() async throws {
        // Given
        let userId = "user_id"

        // When
        let expectedUser = try await LocalStorageUserManager().createUser(id: userId)
        let actualUser = try await LocalStorageUserManager().fetchUser(id: userId)

        // Then
        #expect(actualUser == expectedUser)
    }

    @Test func create_then_update_user() async throws {
        // Given
        let userId = "user_id"
        let currentUser = try #require(await LocalStorageUserManager().createUser(id: userId))

        // When
        let userToUpdate = UserModel(id: currentUser.id, createdAt: currentUser.createdAt)
        try await LocalStorageUserManager().updateUser(userToUpdate)

        // Then
        let updatedUser = try #require(await LocalStorageUserManager().fetchUser(id: userId))

        #expect(userToUpdate == updatedUser)
        #expect(userToUpdate.updatedAt < updatedUser.updatedAt)
    }

    @Test func delete_user() async throws {
        // Given
        let userId = "user_id"

        // When
        _ = try await LocalStorageUserManager().createUser(id: userId)

        try await LocalStorageUserManager().deleteUser(id: userId)

        // Then
        let user = try await LocalStorageUserManager().fetchUser(id: userId)
        #expect(user == nil)
    }
}
