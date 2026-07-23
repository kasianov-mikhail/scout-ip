//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//

import SwiftData
import SwiftUI

struct NotesField: View {
    @Bindable var record: IPRecord
    @Environment(\.modelContext) var modelContext
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Add notes", text: $record.notes, axis: .vertical)
            .accessibilityIdentifier("NotesField")
            .toolbar {
                if isFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        if !record.notes.isEmpty {
                            Button("Clear") {
                                record.notes = ""
                                NotesTracker.cleared()
                            }
                        }

                        Spacer()

                        if record.hasChanges {
                            Button("Save") {
                                do {
                                    try modelContext.save()
                                } catch {
                                }

                                NotesTracker.saved(length: record.notes.count)
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
