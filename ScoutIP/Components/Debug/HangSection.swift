//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct HangSection: View {
    var body: some View {
        Section("Hang") {
            Button("Main Thread Sleep") {
                Thread.sleep(forTimeInterval: .random(in: 1...10))
            }

            Button("Infinite Loop") {
                while true {}
            }
        }
    }
}
