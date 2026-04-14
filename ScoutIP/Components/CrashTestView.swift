//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Logging
import Metrics
import SwiftUI

struct DebugView: View {
    @State private var logCount = 0
    @State private var metricCount = 0

    var body: some View {
        List {
            Section("Logging") {
                Button("Log 10 events") {
                    let logger = Logger(label: "DebugView")
                    for i in 1...10 {
                        logger.info("Debug event \(logCount + i)")
                    }
                    logCount += 10
                }

                Button("Log warning") {
                    Logger(label: "DebugView").warning("Test warning from debug menu")
                }

                Button("Log error") {
                    Logger(label: "DebugView").error("Test error from debug menu")
                }

                Text("Logged: \(logCount) events")
                    .foregroundStyle(.secondary)
            }

            Section("Metrics") {
                Button("Increment counter") {
                    Counter(label: "debug_counter").increment()
                    metricCount += 1
                }

                Button("Record timer (1s)") {
                    Timer(label: "debug_timer").recordSeconds(1.0)
                    metricCount += 1
                }

                Text("Recorded: \(metricCount) metrics")
                    .foregroundStyle(.secondary)
            }

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
        .navigationTitle("Debug")
    }
}
