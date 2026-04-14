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
  @State private var stressRunning = false
  @State private var stressProgress = 0

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

      Section("Stress Test") {
        Button(stressRunning ? "Running..." : "Log 1000 events") {
          runStress(count: 1000)
        }
        .disabled(stressRunning)

        Button(stressRunning ? "Running..." : "Log 100 + 100 metrics") {
          runMixedStress()
        }
        .disabled(stressRunning)

        Button("Rapid fire (10 per second for 30s)") {
          runRapidFire()
        }
        .disabled(stressRunning)

        if stressRunning {
          ProgressView(value: Double(stressProgress), total: 100)
        }
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

  func runStress(count: Int) {
    stressRunning = true
    stressProgress = 0
    let logger = Logger(label: "StressTest")

    Task {
      for i in 1...count {
        let level: Logger.Level = [.info, .warning, .error, .debug].randomElement()!
        logger.log(level: level, "Stress event \(i) of \(count)")

        if i % (count / 100) == 0 {
          stressProgress = i * 100 / count
        }

        if i % 50 == 0 {
          try? await Task.sleep(for: .milliseconds(10))
        }
      }
      logCount += count
      stressRunning = false
    }
  }

  func runMixedStress() {
    stressRunning = true
    stressProgress = 0
    let logger = Logger(label: "StressTest")

    Task {
      for i in 1...100 {
        logger.info("Mixed stress log \(i)")
        Counter(label: "stress_counter_\(i % 5)").increment()
        Timer(label: "stress_timer").recordSeconds(Double.random(in: 0.01...2.0))

        stressProgress = i
        if i % 10 == 0 {
          try? await Task.sleep(for: .milliseconds(10))
        }
      }
      logCount += 100
      metricCount += 200
      stressRunning = false
    }
  }

  func runRapidFire() {
    stressRunning = true
    stressProgress = 0
    let logger = Logger(label: "RapidFire")

    Task {
      for second in 1...30 {
        for burst in 1...10 {
          logger.info("Rapid fire s\(second) b\(burst)")
        }
        Counter(label: "rapid_fire").increment(by: 10)
        stressProgress = second * 100 / 30
        try? await Task.sleep(for: .seconds(1))
      }
      logCount += 300
      metricCount += 30
      stressRunning = false
    }
  }
}
