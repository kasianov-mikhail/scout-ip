//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct CheckmarkView: View {
    @State private var scale = 0.5
    @State private var opacity = 1.0

    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 48))
            .foregroundStyle(.green)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                    scale = 1.0
                }
                withAnimation(.easeOut(duration: 0.5).delay(1.0)) {
                    opacity = 0
                }
            }
    }
}

struct CheckmarkModifier: ViewModifier {
    let isPresented: Bool

    func body(content: Content) -> some View {
        content.overlay {
            if isPresented {
                CheckmarkView()
            }
        }
    }
}

extension View {
    func checkmark(isPresented: Bool) -> some View {
        modifier(CheckmarkModifier(isPresented: isPresented))
    }
}
