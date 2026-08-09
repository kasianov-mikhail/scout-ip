//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//

import Foundation
import SwiftData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init() {
        do {
            // Keep the store at the path used by the NSPersistentContainer-based
            // setup so existing data survives the migration to SwiftData.
            try FileManager.default.createDirectory(
                at: .applicationSupportDirectory, withIntermediateDirectories: true
            )
            // Sync is off: the store stays local, so .none also keeps
            // .automatic from picking up the Scout logging container that the
            // entitlements list.
            let configuration = ModelConfiguration(
                url: URL.applicationSupportDirectory.appendingPathComponent("ScoutIP.sqlite"),
                cloudKitDatabase: .none
            )
            container = try ModelContainer(
                for: IPRecord.self, IPObject.self,
                configurations: configuration
            )
        } catch {
            PersistenceTracker.loadFailure(error: error)
            fatalError("Unresolved error \(error)")
        }
    }
}
