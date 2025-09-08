//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData
import Foundation

enum IPError: LocalizedError {
    case invalidIP(String)

    var errorDescription: String? {
        switch self {
        case .invalidIP(let ip):
            return "Invalid IP address: \(ip)"
        }
    }
}

private struct IPItem: Codable {
    let ip: String
    let city: String?
    let region: String
    let country: String
    let loc: String
    let org: String?
    let postal: String?
    let timezone: String
}

@MainActor
struct InfoProvider {
    let token: String
    let ip: String
    let context: NSManagedObjectContext

    func ipObject() async throws -> IPObject {
        guard let url = URL(string: "https://ipinfo.io/\(ip)?token=\(token)") else {
            throw IPError.invalidIP(ip)
        }

        let data = try await URLSession.shared.data(from: url).0
        let item = try JSONDecoder().decode(IPItem.self, from: data)

        let object = IPObject(context: context)
        object.city = item.city ?? "–"
        object.country = item.country
        object.ip = item.ip
        object.loc = item.loc
        object.org = item.org ?? "–"
        object.postal = item.postal ?? "–"
        object.region = item.region
        object.timezone = item.timezone

        return object
    }
}
