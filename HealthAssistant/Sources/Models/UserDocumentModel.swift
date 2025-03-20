// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - UserDocumentModel

struct UserDocumentModel: Codable, Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, name: String, content: String, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = createdAt
    }

    // MARK: Internal

    let id: String
    var name: String
    let content: String
    let createdAt: Date
    var updatedAt: Date
}

// MARK: Equatable

extension UserDocumentModel: Equatable {
    static func == (lhs: UserDocumentModel, rhs: UserDocumentModel) -> Bool {
        lhs.id == rhs.id
    }
}
