//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import Logging
import Metrics

enum NotesTracker {
    private static let appLogger = Logger(label: "ScoutIP.App")

    static func saved() {
        Counter(label: "notes.saved.count").increment()
        appLogger.debug("NotesSaved")
    }

    static func cleared() {
        Counter(label: "notes.cleared.count").increment()
        appLogger.debug("NotesCleared")
    }
}
