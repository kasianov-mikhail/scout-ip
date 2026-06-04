//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

struct HistoryActionTracker {
    private let appLogger = Logger(label: "ScoutIP.App")

    func rowOpened() {
        Counter(label: "history.row.opened.count").increment()
        appLogger.debug("HistoryRowOpened")
    }

    func favoriteToggled(_ isFavorite: Bool) {
        Counter(label: "history.favorite.toggled.count").increment()
        appLogger.debug("HistoryFavoriteToggled", metadata: ["favorite": "\(isFavorite)"])
    }
}
