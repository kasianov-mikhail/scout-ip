//
// Copyright 2025 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct CrashTestView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("NSException") {
                    row("NSGenericException", subtitle: ".raise()") {
                        NSException(
                            name: .genericException,
                            reason: "Test crash",
                            userInfo: nil
                        ).raise()
                    }
                }

                Section("Signal") {
                    row("SIGABRT", subtitle: "abort()") { abort() }
                    row("SIGTRAP", subtitle: "fatalError()") { fatalError("Test crash") }
                    row("SIGSEGV", subtitle: "Null pointer dereference") {
                        UnsafeMutablePointer<Int>(bitPattern: 0x1)!.pointee = 0
                    }
                    row("SIGFPE", subtitle: "raise(SIGFPE)") { raise(SIGFPE) }
                    row("SIGBUS", subtitle: "raise(SIGBUS)") { raise(SIGBUS) }
                    row("SIGILL", subtitle: "raise(SIGILL)") { raise(SIGILL) }
                }
            }
            .navigationTitle("Crash Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func row(
        _ title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
            }
        } label: {
            VStack(alignment: .leading) {
                Text(title)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    CrashTestView()
}
