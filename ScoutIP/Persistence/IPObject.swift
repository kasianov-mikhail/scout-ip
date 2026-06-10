//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//

import Foundation
import SwiftData

@Model final class IPObject {

    var city = ""
    var country = ""
    var ip = ""
    var loc = ""
    var org = ""
    var postal = ""
    var region = ""
    var timezone = ""

    @Relationship(deleteRule: .cascade, inverse: \IPRecord.object)
    var record: [IPRecord]?

    init(
        city: String, country: String, ip: String, loc: String,
        org: String, postal: String, region: String, timezone: String
    ) {
        self.city = city
        self.country = country
        self.ip = ip
        self.loc = loc
        self.org = org
        self.postal = postal
        self.region = region
        self.timezone = timezone
    }

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
