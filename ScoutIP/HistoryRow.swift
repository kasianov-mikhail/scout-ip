//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData
import SwiftUI

class HistoryItem: Identifiable {
    let records: [IPRecord]

    init(records: [IPRecord]) {
        self.records = records
    }

    var id: String {
        records[0].ip
    }
}

struct HistoryRow: View {
    let item: HistoryItem
    let highlight: String

    @Environment(\.managedObjectContext) var viewContext
    @State private var isConfirmationPresented = false

    var body: some View {
        NavigationLink(destination: HistoryIPList(records: item.records)) {
            HStack {
                Text(title).font(.system(size: 17))
                if item.records.contains(where: { !$0.notes.isEmpty }) {
                    Circle().foregroundColor(.yellow).frame(width: 6, height: 6)
                }
                Spacer()
                Text(item.records.countText).font(.system(size: 16))
            }
            .foregroundColor(highlight.isEmpty ? .primary : .gray)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete") {
                isConfirmationPresented = true
            }
            .tint(.red)
        }
        .confirmationDialog("Are your sure?", isPresented: $isConfirmationPresented) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    hide()
                }
            }
        }
    }

    var title: AttributedString {
        var string = AttributedString(item.records[0].ip)
        var cursor = AttributedString(item.records[0].ip)

        while let range = cursor.range(of: highlight, options: .backwards) {
            string[range].foregroundColor = .primary
            cursor.removeSubrange(range)
        }

        return string
    }

    func hide() {
        let recordIDs = item.records.map(\.objectID)
        let request = NSBatchDeleteRequest(objectIDs: recordIDs)

        do {
            try viewContext.execute(request)

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [NSDeletedObjectsKey: recordIDs],
                into: [viewContext]
            )

        } catch {
        }
    }
}
