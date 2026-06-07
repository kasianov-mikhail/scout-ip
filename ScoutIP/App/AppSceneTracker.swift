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

        default:
            break
        }
    }

    func tabChanged(_ index: Int) {
        let name: String =
            switch index {
            case 0: "info"
            case 1: "history"
            case 2: "debug"
            default: "unknown"
            }
        Counter(label: "app.tab.\(name).count").increment()
        appLogger.debug("TabChanged", metadata: ["tab": "\(name)"])
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
