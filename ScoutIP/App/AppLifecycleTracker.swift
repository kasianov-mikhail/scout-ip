//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

enum AppLifecycleTracker {
    private static let appLogger = Logger(label: "ScoutIP.App")

    static func launch() {
        Counter(label: "app.launch.count").increment()
        appLogger.info("AppLaunched")
    }

    static func scoutSetupFailure(error: Error) {
        appLogger.error("ScoutSetupFailed", metadata: ["error": "\(error)"])
    }
}
