//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct InfoActionTracker {
    private let appLogger = Logger(label: "ScoutIP.App")

    func fieldCopied(key: String) {
        Counter(label: "info.copy.count").increment()
        appLogger.debug("InfoFieldCopied", metadata: ["field": "\(key)"])
    }
}
