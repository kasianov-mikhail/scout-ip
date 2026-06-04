//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct OnboardingTracker {
    private let appLogger = Logger(label: "ScoutIP.App")
    private let defaults = UserDefaults.standard
    private let key = "OnboardingStartedFired"

    func startedIfFirstLaunch() {
        guard !defaults.bool(forKey: key) else {
            return
        }
        defaults.set(true, forKey: key)
        Counter(label: "onboarding.started.count").increment()
        appLogger.info("OnboardingStarted")
    }
}
