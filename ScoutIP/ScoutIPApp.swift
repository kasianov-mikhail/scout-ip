//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Logging
import SwiftUI
import UIKit

let logger = Logger(label: "com.kasianov.ScoutIP")

@main struct ScoutIPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().environment(
                \.managedObjectContext,
                PersistenceController.shared.container.viewContext
            )
        }
    }
}
