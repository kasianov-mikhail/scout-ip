//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct SkeletonView: View {
    @State private var animating = false

    var body: some View {
        Section("Info") {
            ForEach(["IP", "City", "Region", "Country"], id: \.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(animating ? 0.3 : 0.15))
                        .frame(width: CGFloat.random(in: 60...120), height: 16)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                animating = true
            }
        }
    }
}
