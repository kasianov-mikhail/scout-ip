//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct ConfettiPiece: Identifiable {
  let id = UUID()
  let color: Color
  let x: CGFloat
  let rotation: Double
  let delay: Double
}

struct ConfettiView: View {
  @State private var animate = false

  let pieces: [ConfettiPiece] = (0..<30).map { _ in
    ConfettiPiece(
      color: [.red, .blue, .green, .yellow, .orange, .purple, .pink].randomElement()!,
      x: CGFloat.random(in: -150...150),
      rotation: Double.random(in: 0...360),
      delay: Double.random(in: 0...0.3)
    )
  }

  var body: some View {
    ZStack {
      ForEach(pieces) { piece in
        Circle()
          .fill(piece.color)
          .frame(width: 8, height: 8)
          .offset(
            x: animate ? piece.x : 0,
            y: animate ? CGFloat.random(in: 300...600) : -20
          )
          .rotationEffect(.degrees(animate ? piece.rotation : 0))
          .opacity(animate ? 0 : 1)
          .animation(
            .easeOut(duration: 1.5).delay(piece.delay),
            value: animate
          )
      }
    }
    .onAppear {
      animate = true
    }
    .allowsHitTesting(false)
  }
}

struct ConfettiModifier: ViewModifier {
  let isPresented: Bool

  func body(content: Content) -> some View {
    content.overlay {
      if isPresented {
        ConfettiView()
      }
    }
  }
}

extension View {
  func confetti(isPresented: Bool) -> some View {
    modifier(ConfettiModifier(isPresented: isPresented))
  }
}
