//
// Copyright 2025 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Scout
import UIKit

/// The self-hosted Scout server whose address is baked into the build (the
/// `SCOUT_IP` and `SCOUT_API_KEYS` build settings). Empty when the build
/// carries no address.
///
var backends: [Backend] {
    guard let address = Bundle.main.infoDictionary?["SCOUT_IP"] as? String,
        !address.isEmpty,
        let url = URL(string: address)
    else {
        return []
    }

    let apiKey = Bundle.main.infoDictionary?["SCOUT_API_KEYS"] as? String
    return [.server(url: url, apiKey: apiKey?.isEmpty == false ? apiKey : nil)]
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let tracker = AppLifecycleTracker()
        tracker.launch()

        OnboardingTracker().startedIfFirstLaunch()

        Task {
            do {
                try await Scout.setup(backends: backends)
            } catch {
                tracker.scoutSetupFailure(error: error)
            }
        }

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}
