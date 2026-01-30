//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct NotesField: View {
    @ObservedObject var record: IPRecord
    @Environment(\.managedObjectContext) var viewContext
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Add notes", text: $record.notes, axis: .vertical)
            .toolbar {
                if isFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        if !record.notes.isEmpty {
                            Button("Clear") {
                                record.notes = ""
                            }
                        }

                        Spacer()

                        if !record.changedValues().isEmpty {
                            Button("Save") {
                                do {
                                    try viewContext.save()
                                } catch {
                                }

                                isFocused = false
                            }
                        }
                    }
                }
            }
            .autocorrectionDisabled()
            .keyboardType(.alphabet)
            .lineLimit(5)
            .frame(minHeight: 44)
            .focused($isFocused)
    }
}
