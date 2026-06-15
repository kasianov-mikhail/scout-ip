//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

enum HistoryActionTracker {
    private static let appLogger = Logger(label: "ScoutIP.App")

    static func rowOpened() {
        Counter(label: "history.row.opened.count").increment()
        appLogger.debug("HistoryRowOpened")
    }

    static func favoriteToggled(_ isFavorite: Bool) {
        Counter(label: "history.favorite.toggled.count").increment()
        appLogger.debug("HistoryFavoriteToggled", metadata: ["favorite": "\(isFavorite)"])
    }

    static func favoriteFilterToggled(_ isEnabled: Bool) {
        Counter(label: "history.favorite.filter.count").increment()
        appLogger.debug("HistoryFavoriteFilterToggled", metadata: ["enabled": "\(isEnabled)"])
    }
}
