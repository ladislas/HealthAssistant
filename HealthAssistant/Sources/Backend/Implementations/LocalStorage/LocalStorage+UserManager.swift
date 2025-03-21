// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class LocalStorageUserManager: UserManagementProtocol {
    // MARK: Internal

    func createUser(id: String) async throws -> UserModel {
        let now = Date.now
        let user = UserModel(
            id: id,
            createdAt: now
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
        let updatedUser = UserModel(
            id: user.id,
            createdAt: user.createdAt,
            updatedAt: Date.now
        )
        let data = try JSONEncoder().encode(updatedUser)
        try data.write(to: self.userFileURL(for: user.id))
    }

    func deleteUser(id: String) async throws {
        try FileManager.default.removeItem(at: LocalStorage.directory(for: id))
    }

    // MARK: Private

    private func userFileURL(for id: String) throws -> URL {
        try LocalStorage.directory(for: id).appendingPathComponent("user_\(id).json")
    }
}
