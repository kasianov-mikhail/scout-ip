//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

enum FunnelTracker {
    private static let networkLogger = Logger(label: "ScoutIP.Network")

    static func searchPerformed(term: String) {
        Counter(label: "search.performed.count").increment()
        networkLogger.info(
            "SearchPerformed",
            metadata: ["term": "\(term.isEmpty ? "<own_ip>" : term)"]
        )
    }
}
