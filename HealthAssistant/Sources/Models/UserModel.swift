// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - UserModel

struct UserModel: Codable, Identifiable {
    // MARK: Lifecycle

    init(id: String, displayName: String? = nil, createdAt: Date, updatedAt: Date? = nil) {
        self.id = id
        self.displayName = displayName
        self.createdAt = createdAt
        self.updatedAt = updatedAt ?? createdAt
    }

    // MARK: Internal

    let id: String // TODO: (@ladislas) replace by firebase uid
    var displayName: String?
    let createdAt: Date
    let updatedAt: Date
}

// MARK: Equatable

extension UserModel: Equatable {
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.id == rhs.id
    }
}
