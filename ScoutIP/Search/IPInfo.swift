//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData
import Scout
import SwiftUI

class IPInfo: ObservableObject {

    @Published var ip = ""
    @Published var record: IPRecord?
    @Published var errorText: String?

    var allowSearch: Bool {
        ip.isEmpty || ip.isCompleteIP && record?.ip != ip
    }

    @MainActor func record(context: NSManagedObjectContext) async {
        let tracker = IPRecordTracker(source: ip.isEmpty ? .user : .manual)

        do {
            guard let token = try Secrets.dictionary()["IPINFO_KEY"] else {
                errorText = "Token not found"
                tracker.tokenMissing()
                return
            }

            tracker.requested()

            let provider = InfoProvider(token: token, ip: ip, context: context)
            let object = try await provider.ipObject()

            let record = IPRecord(context: context)
            record.date = Date()
            record.id = UUID()
            record.isFavorite = false
            record.isUser = ip.isEmpty  // isUser
            record.object = object
            self.record = record

            do {
                try context.save()
                tracker.saveSuccess()

            } catch {
                tracker.saveFailure(error: error)
                throw error
            }

        } catch {
            errorText = error.localizedDescription
            tracker.failure(error: error)
        }
    }
}
