//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData
import SwiftUI

enum HistoryFilter: String, CaseIterable, Identifiable {
    case all
    case user
    case search

    var id: Self { self }
}

struct HistoryList: View {
    @State private var filter = HistoryFilter.all
    @State private var searchText = ""
    @State private var editMode = EditMode.inactive
    @State private var selection = Set<String>()
    @State private var isConfirmationPresented = false

    @AppStorage("star_only") private var isStarred = false
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(fetchRequest: IPRecord.fetchRequest(), animation: .default)
    var records: FetchedResults<IPRecord>

    var body: some View {
        NavigationView {
            List(selection: $selection) {
                Picker("Filter", selection: $filter) {
                    ForEach(HistoryFilter.allCases) { filter in
                        Text(filter.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)

                ForEach(items) { item in
                    HistoryRow(item: item, highlight: searchText)
                }
            }
            .onDisappear {
                selection = []
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !history.isEmpty {
                        Button {
                            withAnimation {
                                editMode.toggle()
                            }
                        } label: {
                            Image(systemName: "text.badge.checkmark")
                                .foregroundStyle(editMode == .active ? Color.blue : Color.gray)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if editMode == .active {
                        Button {
                            isConfirmationPresented = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        .disabled(selection.isEmpty)
                        .buttonStyle(.plain)
                        .foregroundStyle(selection.isEmpty ? Color.gray : Color.red)
                    } else {
                        StarListButton(isStarred: $isStarred)
                    }
                }
            }
            .overlay {
                if history.isEmpty {
                    VStack(spacing: 8) {
                        Text("NO DATA")
                            .font(.system(size: 14, weight: .medium))

                        if records.count > 0 {
                            Text("Some results are hidden".uppercased())
                                .font(.system(size: 12, weight: .regular))
                        }
                    }
                    .foregroundColor(.gray)
                }
            }
            .confirmationDialog("Are your sure?", isPresented: $isConfirmationPresented) {
                Button("Delete", role: .destructive) {
                    deleteSelected()
                    withAnimation {
                        editMode = .inactive
                    }
                }
                Button("Cancel", role: .cancel) {
                    withAnimation {
                        editMode = .inactive
                    }
                }
            } message: {
                Text("You can't undo this action")
            }
            .listStyle(.plain)
            .environment(\.editMode, $editMode)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .keyboardType(.numberPad)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

    var items: [HistoryItem] {
        Dictionary(grouping: history, by: \.ip)
            .values
            .map(HistoryItem.init)
            .sorted { lhs, rhs in
                lhs.records[0].date > rhs.records[0].date
            }
    }

    var history: [IPRecord] {
        records.filter {
            switch filter {
            case .all:
                return true
            case .user:
                return $0.isUser
            case .search:
                return !$0.isUser
            }
        }.filter {
            if searchText.isEmpty {
                return true
            } else {
                return $0.ip.contains(searchText)
            }
        }.filter {
            if isStarred {
                return $0.isFavorite
            } else {
                return true
            }
        }
    }

    func deleteSelected() {
        let tracker = HistoryDeleteTracker()

        do {
            let records = history.filter { selection.contains($0.ip) }
            let recordIDs = records.map(\.objectID)
            let request = NSBatchDeleteRequest(objectIDs: recordIDs)
            try viewContext.execute(request)

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [NSDeletedObjectsKey: recordIDs],
                into: [viewContext]
            )

            tracker.success(count: recordIDs.count)

        } catch {
            tracker.failure(error: error)
        }
    }
}

extension EditMode {
    fileprivate mutating func toggle() {
        self = (self != .active) ? .active : .inactive
    }
}
