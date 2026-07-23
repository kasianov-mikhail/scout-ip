//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct IPLookupTracker {
    let source: TrackerSource

    // The shared label joins the latency timer and the status counter into a
    // single endpoint on Scout's Network screen.
    private static let endpoint = "GET ipinfo.io"

    private let networkLogger = Logger(label: "ScoutIP.Network")

    func lookupStarted() {
        networkLogger.trace("IPLookupStarted", metadata: ["source": "\(source.rawValue)"])
    }

    func success(duration start: DispatchTime, status: Int?) {
        record(duration: start, status: status)
        Counter(label: "ip.lookup.success.count").increment()
        networkLogger.info("IPLookupSucceeded", metadata: ["source": "\(source.rawValue)"])
    }

    func failure(duration start: DispatchTime, status: Int?, error: Error) {
        record(duration: start, status: status)
        Counter(label: "ip.lookup.failure.count").increment()
        networkLogger.error(
            "IPLookupFailed", metadata: ["source": "\(source.rawValue)", "error": "\(error)"])
    }

    private func record(duration start: DispatchTime, status: Int?) {
        Timer(label: Self.endpoint).recordInterval(since: start)

        let seconds = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
        FloatingPointCounter(label: "ip.lookup.duration.seconds.total").increment(by: seconds)

        if let status {
            Counter(label: Self.endpoint, dimensions: [("status", String(status))]).increment()
        }
    }
}
