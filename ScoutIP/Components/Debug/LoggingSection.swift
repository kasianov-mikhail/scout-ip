//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Logging
import SwiftUI

struct LoggingSection: View {
  @State private var count = 0

  var body: some View {
    Section("Logging") {
      Button("Log 10 events") {
        let logger = Logger(label: "DebugView")
        for i in 1...10 {
          logger.info("Debug event \(count + i)")
        }
        count += 10
      }

      Button("Log warning") {
        Logger(label: "DebugView").warning("Test warning from debug menu")
      }

      Button("Log error") {
        Logger(label: "DebugView").error("Test error from debug menu")
      }

      Text("Logged: \(count) events")
        .foregroundStyle(.secondary)
    }
  }
}
