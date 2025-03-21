// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import FirebaseAuth
import FirebaseAuthCombineSwift
import SwiftUI

@Observable
class AuthManager {
    // MARK: Lifecycle

    init(
        isAuthenticated: Bool = false,
        email: String = "",
        password: String = "",
        uid: String = "",
        errorMessage: String = "",
        isLoading: Bool = false
    ) {
        self.isAuthenticated = isAuthenticated
        self.email = email
        self.password = password
        self.uid = uid
        self.errorMessage = errorMessage
        self.isLoading = isLoading
    }

    // MARK: Internal

    var isAuthenticated = false
    var email = ""
    var password = ""
    var uid = ""
    var errorMessage = ""
    var isLoading = false

    func signIn() async {
        defer {
            self.isLoading = false
        }

        self.isLoading = true
        self.errorMessage = ""

        if self.email.isEmpty || self.password.isEmpty {
            self.errorMessage = "Email and password cannot be empty"
            return
        }

        do {
            let authResult = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            self.isAuthenticated = true
            self.uid = authResult.user.uid

            print("User signed in: \(authResult.user.uid)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error signing in: \(error.localizedDescription)")
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func createUser(email: String, password: String) async -> Bool {
        self.isLoading = true
        self.errorMessage = ""

        defer {
            self.isLoading = false
        }

        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print("User created: \(authResult.user.uid)")
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error creating user: \(error.localizedDescription)")
            return false
        }
    }
}
