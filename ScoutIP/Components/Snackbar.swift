//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

extension View {
    func snackbar(text: Binding<String?>) -> some View {
        modifier(SnackbarModifier(text: text))
    }
}

struct SnackbarModifier: ViewModifier {
    @Binding var text: String?

    func body(content: Content) -> some View {
        ZStack {
            content
            Snackbar(text: $text)
        }
    }
}

struct Snackbar: View {
    @Binding var text: String?

    var body: some View {
        VStack {
            Spacer()
            if let text {
                Text(text)
                    .lineSpacing(2)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.init(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(white: 0.2)))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onTapGesture {
                        self.text = nil
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            self.text = nil
                        }
                    }
            }
        }
        .padding()
        .animation(.spring(), value: text)
    }
}

#Preview {
    Snackbar(text: .constant("The data couldn't be read because it is missing. The data couldn't be read because it is missing."))
}
