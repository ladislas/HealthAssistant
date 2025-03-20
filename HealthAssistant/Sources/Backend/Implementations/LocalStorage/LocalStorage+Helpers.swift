// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

enum LocalStorage {
    static func directory(for id: String) throws -> URL {
        guard !id.isEmpty else {
            throw NSError(domain: "LocalStorage", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid id"])
        }

        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userDir = docs.appendingPathComponent("MockUsers/\(id)", isDirectory: true)

        try fileManager.createDirectory(at: userDir, withIntermediateDirectories: true)

        return userDir
    }
}
