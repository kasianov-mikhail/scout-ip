//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftData
import SwiftUI

struct InfoView: View {
    @Environment(\.modelContext) var modelContext

    @Binding var state: UpdateState
    @Bindable var ipInfo: IPInfo
    @State private var showCheckmark = false
    @State private var showConfetti = false

    @Query(IPRecord.visible)
    var records: [IPRecord]

    var body: some View {
        NavigationStack {
            List {
                Section("Search") {
                    SearchView(state: $state, ipInfo: ipInfo)
                }

                if state == .load {
                    SkeletonView()
                } else if let record = ipInfo.activeRecord, let object = record.object {
                    Section("Info") {
                        ForEach(object.pairs, id: \.key) { pair in
                            HStack {
                                Text(pair.key)
                                Spacer()
                                Text(pair.value).font(.system(size: 16)).multilineTextAlignment(
                                    .trailing)
                            }
                            .textSelection(.enabled)
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = pair.value
                                    InfoActionTracker.fieldCopied(key: pair.key)
                                } label: {
                                    Label("Copy \(pair.key)", systemImage: "doc.on.doc")
                                }
                            }
                        }
                    }
                    Section("Location") {
                        if let location = Location(string: object.loc) {
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
                    if let record = ipInfo.activeRecord, let object = record.object {
                        ShareLink(item: object.shareDescription)
                            .simultaneousGesture(TapGesture().onEnded { ShareTracker.shared() })
                        StarButton(record: record)
                    }
                }
            }
            .checkmark(isPresented: showCheckmark)
            .refreshable {
                state = .refresh
                await ipInfo.record(context: modelContext)
                state = .idle
                if ipInfo.errorText == nil {
                    showCheckmark = true
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        showCheckmark = false
                    }
                }
                requestReview()
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Info")
        }
        .confetti(isPresented: showConfetti)
        .snackbar(text: $ipInfo.errorText)
        .onChange(of: records.count) {
            if records.count > 0 && records.count % 100 == 0 {
                showConfetti = true
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    showConfetti = false
                }
            }
        }
    }

    var ipRecords: [IPRecord] {
        records.filter {
            $0.ip == ipInfo.activeRecord?.ip
        }
    }
}
