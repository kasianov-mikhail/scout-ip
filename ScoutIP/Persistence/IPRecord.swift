//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//

import Foundation
import SwiftData

@Model final class IPRecord {

    static var visible: FetchDescriptor<IPRecord> {
        FetchDescriptor(
            predicate: #Predicate { $0.isHidden == false },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
    }

    var date = Date()
    var isUser = false
    var isFavorite = false
    var isHidden = false
    var notes = ""

    @Relationship(deleteRule: .cascade)
    var object: IPObject

    init(date: Date, isUser: Bool, object: IPObject) {
        self.date = date
        self.isUser = isUser
        self.object = object
    }

    var ip: String {
        object.ip
    }

    var dateText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.unitsStyle = .short

        if date.timeIntervalSinceNow > -60 {
            return "Recently"
        }
        return formatter.string(for: date)!.replacingOccurrences(of: ".", with: "")
    }
}
