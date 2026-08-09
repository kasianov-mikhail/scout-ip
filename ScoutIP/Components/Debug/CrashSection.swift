//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct CrashSection: View {
    var body: some View {
        Section {
            Button {
                NSException(name: .genericException, reason: "Test crash", userInfo: nil).raise()
            } label: {
                Text(verbatim: "NSGenericException")
            }

            Button {
                abort()
            } label: {
                Text(verbatim: "SIGABRT")
            }

            Button {
                fatalError("Test fatal error")
            } label: {
                Text(verbatim: "Fatal Error")
            }

            Button {
                UnsafeMutablePointer<Int>(bitPattern: 0x10)!.pointee = 0
            } label: {
                Text(verbatim: "EXC_BAD_ACCESS")
            }

            Button {
                func recurse(_ n: Int) -> Int {
                    var result = n
                    if n < .max {
                        result += recurse(n + 1)
                    }
                    return result
                }
                _ = recurse(0)
            } label: {
                Text(verbatim: "Stack Overflow")
            }

            Button {
                DispatchQueue.global().async {
                    fatalError("Test crash on background thread")
                }
            } label: {
                Text(verbatim: "Background Thread")
            }
        } header: {
            Text(verbatim: "Crash")
        }
    }
}
