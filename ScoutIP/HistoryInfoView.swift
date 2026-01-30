//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct HistoryInfoView: View {
    @ObservedObject var record: IPRecord

    var body: some View {
        List {
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
        }
        .toolbar {
            ShareLink(item: record.object.shareDescription)
            StarButton(record: record)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(record.dateText)
        .navigationBarTitleDisplayMode(.large)
    }
}
