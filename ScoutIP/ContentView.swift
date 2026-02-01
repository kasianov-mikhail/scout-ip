//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import Logging
import Metrics
import Scout
import SwiftUI

enum UpdateState {
    case idle
    case refresh
    case load
}

private let appLogger = Logger(label: "ScoutIP.App")

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var viewContext

    @State private var index = 0
    @State private var state: UpdateState = .idle
    @State private var isScoutPresented = false
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
        .onChange(of: scenePhase) {
            logPhaseChange()

            if scenePhase == .active {
                handleActions()
            }
        }
        .onShake {
            #if DEBUG
                isScoutPresented = true
            #else
                isScoutPresented =
                    Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
            #endif
        }
        .fullScreenCover(isPresented: $isScoutPresented) {
            HomeView(container: container)
        }
    }

    private func logPhaseChange() {
        switch scenePhase {
        case .active:
            Counter(label: "app.scene.active.count").increment()
            appLogger.info("Scene active")

        case .inactive:
            Counter(label: "app.scene.inactive.count").increment()
            appLogger.notice("Scene inactive")

        case .background:
            Counter(label: "app.scene.background.count").increment()
            appLogger.notice("Scene background")

        @unknown default:
            break
        }
    }

    private func handleActions() {
        appLogger.trace("Handling shortcuts", metadata: ["shortcut": "\(shortcut ?? "nil")"])

        if shortcut == "SearchAction" {
            Counter(label: "app.shortcut.search.count").increment()
            appLogger.debug("Shortcut SearchAction triggered")

            index = 0
            ipInfo.ip = ""

            Task {
                state = .load
                await ipInfo.record(context: viewContext)
                state = .idle
                requestReview()
            }
        }

        if shortcut == "HistoryAction" {
            Counter(label: "app.shortcut.history.count").increment()
            appLogger.debug("Shortcut HistoryAction triggered")

            index = 1
        }

        shortcut = nil
    }
}
