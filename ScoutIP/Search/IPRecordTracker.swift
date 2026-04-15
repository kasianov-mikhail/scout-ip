//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct IPRecordTracker {
    let source: TrackerSource

    private let appLogger = Logger(label: "ScoutIP.App")
    private let storageLogger = Logger(label: "ScoutIP.Storage")

    func requested() {
        appLogger.debug("IPRecordRequested", metadata: ["source": "\(source.rawValue)"])
    }

    func tokenMissing() {
        Counter(label: "ip.record.failure.count").increment()
        appLogger.warning("IPTokenMissing", metadata: ["error": "missing_token"])
    }

    func saveSuccess() {
        Counter(label: "ip.record.success.count").increment()
    }

    func saveFailure(error: Error) {
        Counter(label: "ip.record.save.failure.count").increment()
        storageLogger.error("IPRecordSaveFailed", metadata: ["error": "\(error)"])
    }

    func failure(error: Error) {
        Counter(label: "ip.record.failure.count").increment()
        appLogger.error("IPRecordFailed", metadata: ["error": "\(error)"])
    }
}
