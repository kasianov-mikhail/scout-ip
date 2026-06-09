//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

extension String {
    var emoji: String {
        var s = ""
        for v in unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(127397 + v.value)!)
        }
        return String(s)
    }

    var isPartialIP: Bool {
        wholeMatch(
            of: /(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){0,3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])?/
        ) != nil
    }

    var isCompleteIP: Bool {
        wholeMatch(
            of: /(25[0-5]|2[0-4]\d|1\d{2}|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d{2}|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d{2}|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d{2}|\d{1,2})/
        ) != nil
    }
}
