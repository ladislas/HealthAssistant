// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FilesView: View {
    var body: some View {
        VStack {
            Text("Files View")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.orange)
        }
        .navigationTitle("Files")
    }
}

#Preview {
    TabView {
        Tab("Files", systemImage: "doc") {
            NavigationStack {
                FilesView()
            }
        }
    }
}
