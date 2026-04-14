//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

enum Secrets {

    enum Error: LocalizedError {
        case missingKey(String)

        var errorDescription: String? {
            switch self {
            case .missingKey(let key):
                "\(key) is not configured"
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .missingKey(let key):
                "Set \(key) in Secrets.xcconfig or pass it as a build setting."
            }
        }
    }

    static func value(for key: String) throws -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String, !value.isEmpty else {
            throw Error.missingKey(key)
        }
        return value
    }
}
