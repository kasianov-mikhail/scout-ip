//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics
import SwiftUI

struct AppSceneTracker {
    private let appLogger = Logger(label: "ScoutIP.App")

    func scenePhaseChanged(_ scenePhase: ScenePhase) {
        switch scenePhase {

        case .active:
            Counter(label: "app.scene.active.count").increment()
            appLogger.info("AppSceneActive")

        case .inactive:
            Counter(label: "app.scene.inactive.count").increment()
            appLogger.notice("AppSceneInactive")

        case .background:
            Counter(label: "app.scene.background.count").increment()
            appLogger.notice("AppSceneBackground")

        @unknown default:
            break
        }
    }

    func shortcutTriggered(_ shortcut: String?) {
        appLogger.trace("ShortcutsHandling", metadata: ["shortcut": "\(shortcut ?? "nil")"])

        switch shortcut {

        case "SearchAction":
            Counter(label: "app.shortcut.search.count").increment()
            appLogger.debug("ShortcutSearchTriggered")

        case "HistoryAction":
            Counter(label: "app.shortcut.history.count").increment()
            appLogger.debug("ShortcutHistoryTriggered")

        default:
            break
        }
    }
}
