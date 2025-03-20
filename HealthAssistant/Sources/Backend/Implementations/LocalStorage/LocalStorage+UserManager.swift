// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class LocalStorageUserManager: UserManagementProtocol {
    // MARK: Internal

    func createUser(id: String, displayName: String? = nil) async throws -> UserModel {
        let user = UserModel(
            id: id,
            displayName: displayName,
            createdAt: Date(),
            updatedAt: Date()
        )

        let data = try JSONEncoder().encode(user)
        try data.write(to: self.userFileURL(for: id))

        return user
    }

    func fetchUser(id: String) async throws -> UserModel? {
        let fileURL = try userFileURL(for: id)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }

        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(UserModel.self, from: data)
    }

    func updateUser(_ user: UserModel) async throws {
        let data = try JSONEncoder().encode(user)
        try data.write(to: self.userFileURL(for: user.id))
    }

    func deleteUser(id: String) async throws {
        try FileManager.default.removeItem(at: LocalStorage.directory(for: id))
    }

    // MARK: Private

    private func userFileURL(for id: String) throws -> URL {
        try LocalStorage.directory(for: id).appendingPathComponent("user_data.json")
    }
}
