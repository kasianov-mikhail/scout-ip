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
  @State private var showCheckmark = false
  @State private var showConfetti = false

  @FetchRequest(fetchRequest: IPRecord.fetchRequest(), animation: .none)
  var records: FetchedResults<IPRecord>

  var body: some View {
    NavigationView {
      List {
        Section("Search") {
          SearchView(state: $state, ipInfo: ipInfo)
        }

        if state == .load {
          SkeletonView()
        } else if let record = ipInfo.record, !record.isDeleted {
          Section("Info") {
            ForEach(record.object.pairs, id: \.key) { pair in
              HStack {
                Text(pair.key)
                Spacer()
                Text(pair.value).font(.system(size: 16)).multilineTextAlignment(.trailing)
              }
              .textSelection(.enabled)
              .contextMenu {
                Button {
                  UIPasteboard.general.string = pair.value
                } label: {
                  Label("Copy \(pair.key)", systemImage: "doc.on.doc")
                }
              }
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
            ShareLink(item: record.object.shareDescription)
            StarButton(record: record)
          }
        }
      }
      .checkmark(isPresented: showCheckmark)
      .refreshable {
        state = .refresh
        await ipInfo.record(context: viewContext)
        state = .idle
        if ipInfo.errorText == nil {
          showCheckmark = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showCheckmark = false
          }
        }
        requestReview()
      }
      .scrollDismissesKeyboard(.interactively)
      .navigationTitle("Info")
    }
    .navigationViewStyle(.stack)
    .confetti(isPresented: showConfetti)
    .snackbar(text: $ipInfo.errorText)
    .onChange(of: records.count) {
      if records.count > 0 && records.count % 100 == 0 {
        showConfetti = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          showConfetti = false
        }
      }
    }
  }

  var ipRecords: [IPRecord] {
    records.filter {
      $0.ip == ipInfo.record?.ip
    }
  }
}
