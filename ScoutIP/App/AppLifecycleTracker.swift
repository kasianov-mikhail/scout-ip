//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct AppLifecycleTracker {
    private let appLogger = Logger(label: "ScoutIP.App")

    func launch() {
        Counter(label: "app.launch.count").increment()
        appLogger.info("AppLaunched")
    }

    func scoutSetupFailure(error: Error) {
        appLogger.error("ScoutSetupFailed", metadata: ["error": "\(error)"])
    }
}
