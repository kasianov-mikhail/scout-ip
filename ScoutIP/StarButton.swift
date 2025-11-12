//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct StarButton: View {
    @ObservedObject var record: IPRecord
    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        Button(action: toggle) {
            Image(systemName: record.isFavorite ? "star.fill" : "star")
        }
        .buttonStyle(.plain)
    }

    func toggle() {
        record.isFavorite.toggle()

        do {
            try viewContext.save()
            logger.debug("ToggleStar", metadata: ["Value": .string(record.isFavorite.description)])
        } catch {
            logger.critical("ToggleStarError", metadata: ["Error": .string(error.localizedDescription)])
        }
    }
}
