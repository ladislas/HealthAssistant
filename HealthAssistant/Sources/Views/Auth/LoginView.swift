// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct LoginView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Text("Login View")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.indigo)

            Button {
                self.authManagerViewModel.isAuthenticated = true
            } label: {
                Text("Login")
                    .padding(.horizontal, 20)
            }
            .buttonStyle(.borderedProminent)

            Button {
                self.showSignUpView = true
            }
            label: {
                Text("Sign Up")
                    .padding(.horizontal, 20)
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: self.$showSignUpView) {
            SignUpView()
        }
    }

    // MARK: Private

    @State private var showSignUpView = false

    @Environment(AuthManagerViewModel.self) private var authManagerViewModel
}

#Preview {
    @Previewable var authManagerViewModel = AuthManagerViewModel()

    LoginView()
        .environment(authManagerViewModel)
}
