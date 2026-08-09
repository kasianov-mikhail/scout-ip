//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct HangSection: View {
    var body: some View {
        Section {
            Button {
                Thread.sleep(forTimeInterval: .random(in: 1...10))
            } label: {
                Text(verbatim: "Main Thread Sleep")
            }

            Button {
                while true {}
            } label: {
                Text(verbatim: "Infinite Loop")
            }
        } header: {
            Text(verbatim: "Hang")
        }
    }
}
