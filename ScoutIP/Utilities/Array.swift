//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

extension Array {
    var countText: String {
        count == 1 ? "1 time" : "\(count) times"
    }
}
