// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class LocalStorageUserConsentManager: UserConsentManagementProtocol {
    // MARK: Internal

    func hasUserGivenConsent(id: String) async throws -> Bool {
        let fileURL = try consentFileURL(for: id)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return false }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Bool.self, from: data)
    }

    func giveUserConsent(id: String) async throws {
        try await self.updateUserConsent(id: id, consented: true)
    }

    func revokeUserConsent(id: String) async throws {
        try await self.updateUserConsent(id: id, consented: false)
    }

    // MARK: Private

    private func consentFileURL(for id: String) throws -> URL {
        try LocalStorage.directory(for: id).appendingPathComponent("consent_\(id).json")
    }

    private func updateUserConsent(id: String, consented: Bool) async throws {
        let data = try JSONEncoder().encode(consented)
        try data.write(to: self.consentFileURL(for: id))
    }
}
