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
    
    private let networkLogger = Logger(label: "ScoutIP.Network")
    
    func lookupStarted() {
        networkLogger.trace("IP lookup started", metadata: ["source": "\(source.rawValue)"])
    }

    func success(duration start: DispatchTime) {
        Timer(label: "ip.lookup.duration").recordInterval(since: start)
        Counter(label: "ip.lookup.success.count").increment()
        networkLogger.info("IP lookup succeeded", metadata: ["source": "\(source.rawValue)"])
    }

    func failure(duration start: DispatchTime, error: Error) {
        Timer(label: "ip.lookup.duration").recordInterval(since: start)
        Counter(label: "ip.lookup.failure.count").increment()
        networkLogger.error("IP lookup failed", metadata: ["source": "\(source.rawValue)", "error": "\(error)"])
    }
}
