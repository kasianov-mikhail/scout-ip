//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import SwiftUI

// A single simulated user action. Each case drives the same production
// trackers that organic usage does, with synthesised inputs, so the metrics
// and logs that reach Scout are indistinguishable from real traffic.
enum TrafficEvent: CaseIterable {
    case ownIPLookup
    case manualIPLookup
    case lookupFailure
    case tabSwitch
    case fieldCopied
    case historyOpened
    case historyPresented
    case favoriteToggled
    case favoriteFilterToggled
    case notesSaved
    case notesCleared
    case shared
    case reviewPrompt
    case sceneActive
    case historyDeleted
    case historyDeleteFailure
    case recordSaveFailure
    case tokenMissing
    case persistenceLoadFailure

    // Relative likelihood of each event. The core lookup loop dominates the
    // mix the way it would for a live audience; failures stay rare.
    var weight: Double {
        switch self {
        case .ownIPLookup: 26
        case .manualIPLookup: 14
        case .tabSwitch: 12
        case .fieldCopied: 9
        case .historyOpened: 8
        case .historyPresented: 6
        case .favoriteToggled: 5
        case .notesSaved: 4
        case .shared: 3
        case .favoriteFilterToggled: 3
        case .sceneActive: 2
        case .notesCleared: 2
        case .lookupFailure: 2
        case .reviewPrompt: 1.5
        case .historyDeleted: 1.5
        case .recordSaveFailure: 0.6
        case .tokenMissing: 0.5
        case .historyDeleteFailure: 0.4
        case .persistenceLoadFailure: 0.2
        }
    }

    func fire() {
        switch self {

        case .ownIPLookup:
            lookup(source: .user, term: "")

        case .manualIPLookup:
            lookup(source: .manual, term: Self.randomIP())

        case .lookupFailure:
            FunnelTracker.searchPerformed(term: Self.randomIP())
            let tracker = IPLookupTracker(source: .manual)
            tracker.lookupStarted()
            tracker.failure(
                duration: Self.latency(),
                status: [500, 503, 429, nil].randomElement()!,
                error: SyntheticError.lookup
            )
            IPRecordTracker(source: .manual).failure(error: SyntheticError.lookup)

        case .tabSwitch:
            AppSceneTracker.tabChanged([0, 1, 2].randomElement()!)

        case .fieldCopied:
            let fields = ["ip", "city", "region", "country", "org", "postal", "timezone"]
            InfoActionTracker.fieldCopied(key: fields.randomElement()!)

        case .historyOpened:
            HistoryActionTracker.rowOpened()

        case .historyPresented:
            HistoryActionTracker.historyPresented(total: Int.random(in: 0...240))

        case .favoriteToggled:
            HistoryActionTracker.favoriteToggled(.random())

        case .favoriteFilterToggled:
            HistoryActionTracker.favoriteFilterToggled(.random())

        case .notesSaved:
            NotesTracker.saved(length: Int.random(in: 1...280))

        case .notesCleared:
            NotesTracker.cleared()

        case .shared:
            ShareTracker.shared()

        case .reviewPrompt:
            ReviewTracker.promptRequested()

        case .sceneActive:
            AppSceneTracker.scenePhaseChanged(.active)

        case .historyDeleted:
            HistoryDeleteTracker.success(count: Int.random(in: 1...5))

        case .historyDeleteFailure:
            HistoryDeleteTracker.failure(error: SyntheticError.storage)

        case .recordSaveFailure:
            IPRecordTracker(source: .user).saveFailure(error: SyntheticError.storage)

        case .tokenMissing:
            IPRecordTracker(source: .manual).tokenMissing()

        case .persistenceLoadFailure:
            PersistenceTracker.loadFailure(error: SyntheticError.storage)
        }
    }

    private func lookup(source: TrackerSource, term: String) {
        FunnelTracker.searchPerformed(term: term)
        let tracker = IPLookupTracker(source: source)
        tracker.lookupStarted()
        tracker.success(duration: Self.latency(), status: 200)
        IPRecordTracker(source: source).saveSuccess()
    }

    // A DispatchTime placed a plausible request latency in the past, so the
    // tracker records a realistic interval when it diffs it against now.
    private static func latency() -> DispatchTime {
        DispatchTime.now() + .milliseconds(-Int.random(in: 40...900))
    }

    private static func randomIP() -> String {
        (1...4).map { _ in String(Int.random(in: 1...254)) }.joined(separator: ".")
    }

    static func random() -> TrafficEvent {
        let total = allCases.reduce(0) { $0 + $1.weight }
        var roll = Double.random(in: 0..<total)
        for event in allCases {
            roll -= event.weight
            if roll < 0 {
                return event
            }
        }
        return .ownIPLookup
    }
}

enum SyntheticError: Error {
    case lookup
    case storage
}
