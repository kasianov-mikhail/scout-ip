//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//

import SwiftData
import SwiftUI
import UIKit

@main struct ScoutIPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // The app saves explicitly at every mutation point, matching the
        // previous Core Data behaviour.
        PersistenceController.shared.container.mainContext.autosaveEnabled = false
    }

    var body: some Scene {
        WindowGroup {
            ContentView().modelContainer(PersistenceController.shared.container)
        }
    }
}
