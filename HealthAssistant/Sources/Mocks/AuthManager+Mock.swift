// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

extension AuthManager {
    static var mock: AuthManager {
        .init(isAuthenticated: true, email: "mock@example.com", uid: "qWAbUo34DRT6p8wTIaheYGCzz562")
    }
}
