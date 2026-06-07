//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct ReviewTracker {
    private let appLogger = Logger(label: "ScoutIP.App")

    func promptRequested() {
        Counter(label: "review.prompt.requested.count").increment()
        appLogger.info("ReviewPromptRequested")
    }
}
