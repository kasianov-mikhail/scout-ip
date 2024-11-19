//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import CoreData

class IPRecord: NSManagedObject, Identifiable {

    class func fetchRequest() -> NSFetchRequest<IPRecord> {
        let request = NSFetchRequest<IPRecord>(entityName: "IPRecord")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \IPRecord.date, ascending: false)]
        request.predicate = NSPredicate(format: "isHidden == false")
        return request
    }

    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var isUser: Bool
    @NSManaged var isFavorite: Bool
    @NSManaged var object: IPObject
    @NSManaged var notes: String

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
