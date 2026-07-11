//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct CrashSection: View {
    var body: some View {
        Section("Crash") {
            Button("NSGenericException") {
                NSException(name: .genericException, reason: "Test crash", userInfo: nil).raise()
            }

            Button("SIGABRT") {
                abort()
            }

            Button("Fatal Error") {
                fatalError("Test fatal error")
            }

            Button("EXC_BAD_ACCESS") {
                UnsafeMutablePointer<Int>(bitPattern: 0x10)!.pointee = 0
            }

            Button("Stack Overflow") {
                func recurse(_ n: Int) -> Int {
                    var result = n
                    if n < .max {
                        result += recurse(n + 1)
                    }
                    return result
                }
                _ = recurse(0)
            }

            Button("Background Thread") {
                DispatchQueue.global().async {
                    fatalError("Test crash on background thread")
                }
            }
        }
    }
}
