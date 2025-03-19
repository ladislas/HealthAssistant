// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SignUpView: View {
    // MARK: Internal

    var body: some View {
        Text("Sign-up View")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.orange)

        Button {
            self.authManagerViewModel.isAuthenticated = true
        } label: {
            Text("Sign Up")
                .padding(.horizontal, 20)
        }
        .buttonStyle(.borderedProminent)
    }

    // MARK: Private

    @Environment(AuthManagerViewModel.self) private var authManagerViewModel
}

#Preview {
    @Previewable var authManagerViewModel = AuthManagerViewModel()

    SignUpView()
        .environment(authManagerViewModel)
}
