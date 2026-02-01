//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct HistoryDeleteTracker {
    private let storageLogger = Logger(label: "ScoutIP.Storage")
    
    func success(count: Int) {
        Counter(label: "history.delete.count").increment(by: Int64(count))
        storageLogger.info("HistoryDeleted", metadata: ["count": "\(count)"])
    }

    func failure(error: Error) {
        Counter(label: "history.delete.failure.count").increment()
        storageLogger.error("HistoryDeleteFailed", metadata: ["error": "\(error)"])
    }
}
