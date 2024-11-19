//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

struct Secrets {
    enum Error: LocalizedError {
        case missingResource
        case wrongFormat

        var errorDescription: String? {
            switch self {
            case .missingResource:
                return "\(resource).json is missing"
            case .wrongFormat:
                return
                    "\(resource).json has the wrong format. Expected a dictionary of string key-value pairs."
            }
        }
    }

    static let resource = "Secrets"

    static func dictionary() throws -> [String: String] {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            throw Error.missingResource
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: String] else {
            throw Error.wrongFormat
        }
        return json
    }
}
