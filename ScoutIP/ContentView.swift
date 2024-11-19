//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import Scout
import SwiftUI

enum UpdateState {
    case idle
    case refresh
    case load
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var viewContext

    @State private var index = 0
    @State private var state: UpdateState = .idle
    @State private var isAnalyticsPresented = false
    @StateObject private var ipInfo = IPInfo()

    var body: some View {
        TabView(selection: $index) {
            InfoView(state: $state, ipInfo: ipInfo)
                .tabItem {
                    Image(systemName: "info.circle").environment(\.symbolVariants, .none)
                    Text("Info")
                }
                .tag(0)

            HistoryList()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("History")
                }
                .tag(1)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                handleActions()
            }
        }
        .onShake {
            #if DEBUG
                isAnalyticsPresented = true
            #else
                isAnalyticsPresented =
                    Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
            #endif
        }
        .fullScreenCover(isPresented: $isAnalyticsPresented) {
            AnalyticsView(container: container)
        }
    }

    private func handleActions() {
        if shortcut == "SearchAction" {
            index = 0
            ipInfo.ip = ""
            Task {
                state = .load
                await ipInfo.record(context: viewContext)
                state = .idle
                requestReview()
            }
            logger.info("ShortcutSearch")
        }

        if shortcut == "HistoryAction" {
            index = 1
            logger.info("ShortcutHistory")
        }

        shortcut = nil
    }
}
