//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

enum OnboardingTracker {
    private static let appLogger = Logger(label: "ScoutIP.App")
    private static let key = "OnboardingStartedFired"

    static func startedIfFirstLaunch() {
        guard !UserDefaults.standard.bool(forKey: key) else {
            return
        }
        UserDefaults.standard.set(true, forKey: key)
        Counter(label: "onboarding.started.count").increment()
        appLogger.info("OnboardingStarted")
    }
}
