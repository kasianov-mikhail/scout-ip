//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData
import SwiftUI
import Metrics

struct HistoryIPList: View {
    let records: [IPRecord]

    @Environment(\.managedObjectContext) var viewContext
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
                Text("NO DATA")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                    .frame(maxHeight: .infinity)
            }
        }
        .toolbar {
            if let record = records.first {
                ShareLink(item: record.object.shareDescription).onAppear {
                    logger.debug("ShareInfo", metadata: ["Source": .string("HistoryIPList")])
                }
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
            let recordIDs = records.map(\.objectID)
            let request = NSBatchDeleteRequest(objectIDs: recordIDs)

            do {
                try viewContext.execute(request)
                let randomLabel = ["RemoveIP", "DeleteIP", "PurgeIP"].randomElement()!
                FloatingPointCounter(label: randomLabel).increment(by: Double(records.count))
            } catch {
                logger.critical("DeleteRecordsError", metadata: ["error": .string(error.localizedDescription)])
            }

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [NSDeletedObjectsKey: recordIDs],
                into: [viewContext]
            )
        }
    }
}
