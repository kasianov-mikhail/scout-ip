//
// Copyright 2025 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import Scout
import UIKit

/// The backends Scout reads from and syncs to. CloudKit is always included;
/// the self-hosted Scout server (the `SCOUT_IP` and `SCOUT_API_KEYS` build
/// settings) is added when an address is baked into the build. With both
/// present, the analytics screen shows a picker to choose which one reads are
/// served from.
///
var backends: [Backend] {
    let cloudKit = Backend.cloudKit(container: CKContainer(identifier: "iCloud.Logging.Scout.0001"))
    let info = Bundle.main.infoDictionary

    guard let address = info?["SCOUT_IP"] as? String, !address.isEmpty, let url = URL(string: address) else {
        return [cloudKit]
    }

    guard let apiKey = info?["SCOUT_API_KEYS"] as? String, !apiKey.isEmpty else {
        return [cloudKit]
    }

    return [Backend.server(url: url, apiKey: apiKey), cloudKit]
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        AppLifecycleTracker.launch()

        OnboardingTracker.startedIfFirstLaunch()

        Task {
            do {
                try await Scout.setup(backends: backends)
            } catch {
                AppLifecycleTracker.scoutSetupFailure(error: error)
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
