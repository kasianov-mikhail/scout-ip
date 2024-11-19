//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct InfoView: View {
    @Environment(\.managedObjectContext) var viewContext

    @Binding var state: UpdateState
    @ObservedObject var ipInfo: IPInfo

    @FetchRequest(fetchRequest: IPRecord.fetchRequest(), animation: .none)
    var records: FetchedResults<IPRecord>

    var body: some View {
        NavigationView {
            List {
                Section("Search") {
                    SearchView(state: $state, ipInfo: ipInfo)
                }

                if let record = ipInfo.record, !record.isDeleted {
                    Section("Info") {
                        ForEach(record.object.pairs, id: \.key) { pair in
                            HStack {
                                Text(pair.key)
                                Spacer()
                                Text(pair.value).font(.system(size: 16)).multilineTextAlignment(.trailing)
                            }
                            .textSelection(.enabled)
                        }
                    }
                    Section("Location") {
                        if let location = Location(string: record.object.loc) {
                            MapView(location: location)
                        }
                    }
                    Section("Notes") {
                        NotesField(record: record)
                    }
                    Section("History") {
                        NavigationLink(destination: HistoryIPList(records: ipRecords)) {
                            HStack {
                                Text(record.ip).font(.system(size: 17))
                                Spacer()
                                Text(ipRecords.countText).font(.system(size: 16))
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if let record = ipInfo.record, !record.isDeleted {
                        ShareLink(item: record.object.shareDescription).onAppear {
                            logger.debug("ShareInfo", metadata: ["Source": .string("InfoView")])
                        }
                        StarButton(record: record)
                    }
                }
            }
            .refreshable {
                state = .refresh
                await ipInfo.record(context: viewContext)
                state = .idle
                requestReview()
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Info")
        }
        .navigationViewStyle(.stack)
        .snackbar(text: $ipInfo.errorText)
    }

    var ipRecords: [IPRecord] {
        records.filter {
            $0.ip == ipInfo.record?.ip
        }
    }
}
