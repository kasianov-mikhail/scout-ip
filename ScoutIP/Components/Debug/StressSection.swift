//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Logging
import Metrics
import SwiftUI

struct StressSection: View {
    @State private var running = false
    @State private var progress = 0

    var body: some View {
        Section("Stress Test") {
            Button(running ? "Running..." : "Log 1000 events") {
                runStress(count: 1000)
            }
            .disabled(running)

            Button(running ? "Running..." : "Log 100 + 100 metrics") {
                runMixedStress()
            }
            .disabled(running)

            Button("Rapid fire (10 per second for 30s)") {
                runRapidFire()
            }
            .disabled(running)

            if running {
                ProgressView(value: Double(progress), total: 100)
            }
        }
    }

    func runStress(count: Int) {
        running = true
        progress = 0
        let logger = Logger(label: "StressTest")

        Task {
            for i in 1...count {
                let level: Logger.Level = [.info, .warning, .error, .debug].randomElement()!
                logger.log(level: level, "Stress event \(i) of \(count)")

                if i % (count / 100) == 0 {
                    progress = i * 100 / count
                }

                if i % 50 == 0 {
                    try? await Task.sleep(for: .milliseconds(10))
                }
            }
            running = false
        }
    }

    func runMixedStress() {
        running = true
        progress = 0
        let logger = Logger(label: "StressTest")

        Task {
            for i in 1...100 {
                logger.info("Mixed stress log \(i)")
                Counter(label: "stress_counter_\(i % 5)").increment()
                Timer(label: "stress_timer").recordSeconds(Double.random(in: 0.01...2.0))

                progress = i
                if i % 10 == 0 {
                    try? await Task.sleep(for: .milliseconds(10))
                }
            }
            running = false
        }
    }

    func runRapidFire() {
        running = true
        progress = 0
        let logger = Logger(label: "RapidFire")

        Task {
            for second in 1...30 {
                for burst in 1...10 {
                    logger.info("Rapid fire s\(second) b\(burst)")
                }
                Counter(label: "rapid_fire").increment(by: 10)
                progress = second * 100 / 30
                try? await Task.sleep(for: .seconds(1))
            }
            running = false
        }
    }
}
