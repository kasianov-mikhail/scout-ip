//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftData
import SwiftUI

struct HistoryIPList: View {
    let records: [IPRecord]

    @Environment(\.modelContext) var modelContext
    @AppStorage("star_only") var isStarred = false

    var body: some View {
        List {
            ForEach(records) { record in
                NavigationLink(destination: HistoryInfoView(record: record)) {
                    HStack {
                        Text(record.ip).font(.system(size: 17))
                        if !record.notes.isEmpty {
                            Image(systemName: "note.text").foregroundColor(.yellow)
                        }
                        Spacer()
                        Text(record.dateText).font(.system(size: 16))
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .overlay {
            if records.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "NO DATA",
                    subtitle: "No records for this IP"
                )
            }
        }
        .toolbar {
            if let object = records.first?.object {
                ShareLink(item: object.shareDescription)
                    .simultaneousGesture(TapGesture().onEnded { ShareTracker.shared() })
            }
            StarListButton(isStarred: $isStarred)
        }
        .listStyle(.plain)
        .navigationTitle("IP History")
        .navigationBarTitleDisplayMode(.inline)
    }

    func delete(offsets: IndexSet) {
        withAnimation {
            let records = offsets.map { self.records[$0] }

            do {
                for record in records {
                    modelContext.delete(record)
                }
                try modelContext.save()
                HistoryDeleteTracker.success(count: records.count)

            } catch {
                HistoryDeleteTracker.failure(error: error)
            }
        }
    }
}
