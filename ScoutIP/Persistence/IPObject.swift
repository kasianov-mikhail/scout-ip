//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation
import CoreData

class IPObject: NSManagedObject, Identifiable {

    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var ip: String
    @NSManaged var loc: String
    @NSManaged var org: String
    @NSManaged var postal: String
    @NSManaged var region: String
    @NSManaged var timezone: String

    var pairs: KeyValuePairs<String, String> {
        [
            "IP": ip,
            "City": city,
            "Region": region,
            "Country": "\(country.emoji) \(country)",
            "Location": loc.replacingOccurrences(of: ",", with: ", "),
            "Organisation": org,
            "Postal": postal,
            "Timezone": timezone,
        ]
    }

    var params: [String: String] {
        pairs.reduce(into: [:]) { result, pair in
            result[pair.key] = pair.value
        }
    }

    var shareDescription: String {
        pairs.reduce(into: "") { result, pair in
            result += "\(pair.key) – \(pair.value)\n"
        }
        .trimmingCharacters(in: .newlines)
    }
}
