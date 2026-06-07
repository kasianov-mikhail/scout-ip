//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct ShareTracker {
    private let appLogger = Logger(label: "ScoutIP.App")

    func shared() {
        Counter(label: "share.count").increment()
        appLogger.info("Shared")
    }
}
