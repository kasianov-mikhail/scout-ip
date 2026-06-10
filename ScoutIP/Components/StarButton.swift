//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//

import SwiftData
import SwiftUI

struct StarButton: View {
    var record: IPRecord
    @Environment(\.modelContext) var modelContext

    private let tracker = HistoryActionTracker()

    var body: some View {
        Button(action: toggle) {
            Image(systemName: record.isFavorite ? "star.fill" : "star")
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("StarButton")
    }

    func toggle() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        record.isFavorite.toggle()

        do {
            try modelContext.save()
        } catch {
        }

        tracker.favoriteToggled(record.isFavorite)
    }
}
