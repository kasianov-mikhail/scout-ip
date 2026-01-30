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
        do {
            guard let token = try Secrets.dictionary()["IPINFO_KEY"] else {
                errorText = "Token not found"
                return
            }

            let provider = InfoProvider(token: token, ip: ip, context: context)
            let object = try await provider.ipObject()

            let record = IPRecord(context: context)
            record.date = Date()
            record.id = UUID()
            record.isFavorite = false
            record.isUser = ip.isEmpty  // isUser
            record.object = object
            self.record = record

            try context.save()

        } catch {
            errorText = error.localizedDescription
        }
    }
}
