// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct LoginView: View {
    // MARK: Internal

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Health Assistant")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.indigo)
                .padding(.bottom, 30)

            VStack(spacing: 15) {
                @Bindable var authManager = self.authManager

                TextField("Email", text: $authManager.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Password", text: $authManager.password)
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
                Task {
                    await self.authManager.signIn()
                }
            } label: {
                if self.authManager.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(self.authManager.isLoading)
            .padding(.horizontal)

            Button {
                self.showSignUpView = true
            } label: {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.indigo)
            }
            .padding(.top, 10)

            Spacer()
        }
        .sheet(isPresented: self.$showSignUpView) {
            SignUpView()
        }
    }

    // MARK: Private

    @State private var showSignUpView = false

    @Environment(AuthManager.self) private var authManager
}

#Preview {
    @Previewable var authManager = AuthManager()

    LoginView()
        .environment(authManager)
}
