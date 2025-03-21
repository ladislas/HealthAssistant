// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SignUpView: View {
    // MARK: Internal

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Create Account")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.indigo)
                .padding(.bottom, 30)

            VStack(spacing: 15) {
                TextField("Email", text: self.$email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Confirm Password", text: self.$confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            if !self.authManager.errorMessage.isEmpty {
                Text(self.authManager.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button {
                self.signUp()
            } label: {
                if self.authManager.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(self.authManager.isLoading)
            .padding(.horizontal)

            Button {
                self.dismiss()
            } label: {
                Text("Already have an account? Login")
                    .foregroundColor(.indigo)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .onAppear {
            self.authManager.errorMessage = ""
        }
    }

    // MARK: Private

    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    private func signUp() {
        // Validate inputs
        if self.email.isEmpty || self.password.isEmpty || self.confirmPassword.isEmpty {
            self.authManager.errorMessage = "All fields are required"
            return
        }

        if self.password != self.confirmPassword {
            self.authManager.errorMessage = "Passwords don't match"
            return
        }

        if self.password.count < 6 {
            self.authManager.errorMessage = "Password must be at least 6 characters"
            return
        }

        Task {
            let success = await authManager.createUser(email: self.email, password: self.password)
            if success {
                self.dismiss()
            }
        }
    }
}

#Preview {
    @Previewable var authManager = AuthManager()

    SignUpView()
        .environment(authManager)
}
