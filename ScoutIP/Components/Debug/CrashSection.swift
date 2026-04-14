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
    }
  }
}
