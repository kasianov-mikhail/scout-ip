//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData
import Foundation

struct IPError: LocalizedError {
    let ip: String

    var errorDescription: String? {
        "Invalid IP address: \(ip)"
    }
}

struct BogonError: LocalizedError {
    let ip: String

    var errorDescription: String? {
        "\(ip) is a private or reserved IP address"
    }
}

private struct BogonItem: Codable {
    let ip: String
    let bogon: Bool
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

@MainActor struct InfoProvider {
    let token: String
    let ip: String
    let context: NSManagedObjectContext

    func ipObject() async throws -> IPObject {
        guard let url = URL(string: "https://ipinfo.io/\(ip)?token=\(token)") else {
            throw IPError(ip: ip)
        }

        let tracker = IPLookupTracker(source: ip.isEmpty ? .user : .manual)
        let start = DispatchTime.now()
        tracker.lookupStarted()
        FunnelTracker().searchPerformed(term: ip)

        do {
            let data = try await URLSession.shared.data(from: url).0
            if let bogon = try? JSONDecoder().decode(BogonItem.self, from: data), bogon.bogon {
                throw BogonError(ip: bogon.ip)
            }
            let item = try JSONDecoder().decode(IPItem.self, from: data)
            tracker.success(duration: start)
            return IPObject(item: item, context: context)

        } catch {
            tracker.failure(duration: start, error: error)
            throw error
        }
    }
}

extension IPObject {
    fileprivate convenience init(item: IPItem, context: NSManagedObjectContext) {
        self.init(context: context)
        city = item.city ?? "–"
        country = item.country
        ip = item.ip
        loc = item.loc
        org = item.org ?? "–"
        postal = item.postal ?? "–"
        region = item.region
        timezone = item.timezone
    }
}
