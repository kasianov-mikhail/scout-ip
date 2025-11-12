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
    @State private var text = ""
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
        TextField("My IP", text: $text)
            .foregroundStyle(ipInfo.ip.isPartialIP ? Color.primary : Color.red)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if isFocused {
                        if !ipInfo.ip.isEmpty {
                            Button("Clear") {
                                ipInfo.ip = ""
                                logger.trace("ClearSearch")
                            }
                            .padding(.horizontal)
                            .fixedSize()
                        }

                        Spacer()

                        if ipInfo.allowSearch && state == .idle {
                            Button("Search") {
                                isFocused = false
                                searchIP()
                                logger.trace("SearchIP")
                            }
                            .padding(.horizontal)
                            .fixedSize()
                        }
                    }
                }
            }
            .onTapGesture {
                isFocused = true
            }
            .onChange(of: text) {
                ipInfo.ip = text.replacingOccurrences(of: ",", with: ".")
            }
            .onChange(of: ipInfo.ip) {
                text = ipInfo.ip
            }
            .onChange(of: state) {
                if state != .idle {
                    isFocused = false
                }
            }
            .focused($isFocused)
            .foregroundStyle(.blue)
            .keyboardType(.decimalPad)
            .accessibilityIdentifier("IP Search Field")
    }

    private func searchButton(enabled: Bool) -> some View {
        Button(action: searchIP) {
            Image(systemName: "magnifyingglass")
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .foregroundStyle(enabled ? .blue : .gray)
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
