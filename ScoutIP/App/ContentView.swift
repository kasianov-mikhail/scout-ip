//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import Scout
import SwiftData
import SwiftUI

enum UpdateState {
    case idle
    case refresh
    case load
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext

    @State private var index = 0
    @State private var state: UpdateState = .idle
    @State private var ipInfo = IPInfo()

    private var isBeta: Bool {
        #if DEBUG
            return true
        #else
            return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        #endif
    }

    var body: some View {
        TabView(selection: $index) {
            InfoView(state: $state, ipInfo: ipInfo)
                .tabItem {
                    Image(systemName: "info.circle").environment(\.symbolVariants, .none)
                    Text("Info")
                }
                .tag(0)
                .accessibilityIdentifier("InfoTab")

            HistoryList()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("History")
                }
                .tag(1)
                .accessibilityIdentifier("HistoryTab")

            if isBeta {
                DebugView()
                    .tabItem {
                        Image(systemName: "ant")
                        Text("Debug")
                    }
                    .tag(2)

                HomeView(backends: backends)
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Scout")
                    }
                    .tag(3)
            }
        }
        .onChange(of: scenePhase) {
            AppSceneTracker.scenePhaseChanged(scenePhase)

            if scenePhase == .active {
                handleActions()
            }
        }
        .onChange(of: index) { _, newIndex in
            AppSceneTracker.tabChanged(newIndex)
        }
    }

    private func handleActions() {
        AppSceneTracker.shortcutTriggered(shortcut)

        if shortcut == "SearchAction" {
            index = 0
            ipInfo.ip = ""

            Task {
                state = .load
                await ipInfo.record(context: modelContext)
                state = .idle
                requestReview()
            }
        }

        if shortcut == "HistoryAction" {
            index = 1
        }

        shortcut = nil
    }
}
