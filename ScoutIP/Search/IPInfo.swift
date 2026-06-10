//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//

import Observation
import Scout
import SwiftData
import SwiftUI

@Observable class IPInfo {

    var ip = ""
    var record: IPRecord?
    var errorText: String?

    // The record can be deleted from the history while it is still
    // referenced here, so reading its properties is no longer safe.
    var activeRecord: IPRecord? {
        guard let record, record.modelContext != nil, !record.isDeleted else {
            return nil
        }
        return record
    }

    var allowSearch: Bool {
        ip.isEmpty || ip.isCompleteIP && activeRecord?.ip != ip
    }

    @MainActor func record(context: ModelContext) async {
        let tracker = IPRecordTracker(source: ip.isEmpty ? .user : .manual)

        do {
            let token: String
            if let keychainToken = KeychainHelper.load(key: "IPINFO_KEY") {
                token = keychainToken
            } else if let plistToken = Bundle.main.infoDictionary?["IPINFO_KEY"] as? String,
                !plistToken.isEmpty
            {
                KeychainHelper.save(key: "IPINFO_KEY", value: plistToken)
                token = plistToken
            } else {
                return
            }

            tracker.requested()

            let provider = InfoProvider(token: token, ip: ip, context: context)
            let object = try await provider.ipObject()

            let record = IPRecord(date: Date(), isUser: ip.isEmpty, object: object)
            context.insert(record)
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
