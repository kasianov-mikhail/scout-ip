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
    enum Source: String {
        case user
        case manual
    }
    
    private let source: Source
    private let appLogger = Logger(label: "ScoutIP.App")
    private let storageLogger = Logger(label: "ScoutIP.Storage")
    
    init(source: Source) {
        self.source = source
    }
    
    func requested() {
        appLogger.debug("IP record requested", metadata: ["source": "\(source.rawValue)"])
    }

    func tokenMissing() {
        Counter(label: "ip.record.failure.count").increment()
        appLogger.warning("IP info token missing", metadata: ["error": "missing_token"])
    }

    func saveSuccess() {
        Counter(label: "ip.record.success.count").increment()
    }

    func saveFailure(error: Error) {
        Counter(label: "ip.record.save.failure.count").increment()
        storageLogger.error("Failed to save IP record", metadata: ["error": "\(error)"])
    }

    func failure(error: Error) {
        Counter(label: "ip.record.failure.count").increment()
        appLogger.error("IP record failed", metadata: ["error": "\(error)"])
    }
}
