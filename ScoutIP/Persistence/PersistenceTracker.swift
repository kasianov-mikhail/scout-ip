//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct PersistenceTracker {
    private let storageLogger = Logger(label: "ScoutIP.Storage")
    
    func loadFailure(error: Error) {
        Counter(label: "persistence.load.failure.count").increment()
        storageLogger.critical("PersistenceLoadFailed", metadata: ["error": "\(error)"])
    }
}
