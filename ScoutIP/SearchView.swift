//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct SearchView: View {
    @Environment(\.managedObjectContext) var viewContext

    @Binding var state: UpdateState
    @ObservedObject var ipInfo: IPInfo
    @State private var color = Color.primary
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            searchField

            switch state {
            case .idle:
                searchButton(enabled: ipInfo.allowSearch)
            case .refresh:
                searchButton(enabled: false)
            case .load:
                ProgressView()
            }
        }
        .buttonStyle(.plain)
        .frame(height: 44)
    }

    private var searchField: some View {
        TextField("My IP", text: $ipInfo.ip)
            .foregroundColor(color)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if isFocused {
                        if !ipInfo.ip.isEmpty {
                            Button("Clear") {
                                ipInfo.ip = ""
                                logger.trace("ClearSearch")
                            }
                        }

                        Spacer()

                        if ipInfo.allowSearch && state == .idle {
                            Button("Search") {
                                isFocused = false
                                searchIP()
                                logger.trace("SearchIP")
                            }
                        }
                    }
                }
            }
            .onTapGesture {
                isFocused = true
            }
            .onChange(of: ipInfo.ip) { ip in
                ipInfo.ip = ip.replacingOccurrences(of: ",", with: ".")
                color = ipInfo.ip.isPartialIP ? .primary : .red // iOS 17 workaround
            }
            .onChange(of: state) { state in
                if state != .idle {
                    isFocused = false
                }
            }
            .focused($isFocused)
            .foregroundColor(.blue)
            .keyboardType(.decimalPad)
            .accessibilityIdentifier("IP Search Field")
    }

    private func searchButton(enabled: Bool) -> some View {
        Button(action: searchIP) {
            Image(systemName: "magnifyingglass")
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .foregroundColor(enabled ? .blue : .gray)
        .accessibilityIdentifier("IP Search Button")
    }

    private func searchIP() {
        Task {
            state = .load
            await ipInfo.record(context: viewContext)
            state = .idle
            requestReview()
        }
    }
}
