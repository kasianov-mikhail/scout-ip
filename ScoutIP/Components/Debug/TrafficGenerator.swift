//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Observation

@MainActor @Observable final class TrafficGenerator {
    static let shared = TrafficGenerator()

    private(set) var isRunning = false
    private(set) var emitted = 0

    private var task: Task<Void, Never>?

    private init() {}

    func toggle(_ on: Bool) {
        on ? start() : stop()
    }

    func start() {
        guard task == nil else {
            return
        }
        isRunning = true
        task = Task { [weak self] in
            await self?.run()
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        isRunning = false
    }

    private func run() async {
        while !Task.isCancelled {
            TrafficEvent.random().fire()
            emitted += 1

            try? await Task.sleep(for: .seconds(Self.nextInterval()))
        }
    }

    // Exponential inter-arrival times produce a Poisson stream averaging one
    // event per second, rather than a robotic fixed cadence.
    private static func nextInterval() -> Double {
        let u = Double.random(in: .leastNonzeroMagnitude...1)
        return -log(u)
    }
}
