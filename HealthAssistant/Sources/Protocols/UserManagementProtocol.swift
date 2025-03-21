// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol UserManagementProtocol {
    func createUser(id: String) async throws -> UserModel
    func fetchUser(id: String) async throws -> UserModel?
    func updateUser(_ user: UserModel) async throws
    func deleteUser(id: String) async throws
}
