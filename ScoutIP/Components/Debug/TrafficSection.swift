//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct TrafficSection: View {
    private let generator = TrafficGenerator.shared

    var body: some View {
        Section {
            Toggle(
                isOn: Binding(get: { generator.isRunning }, set: { generator.toggle($0) })
            ) {
                Text(verbatim: "Simulated Traffic")
            }

            if generator.isRunning {
                LabeledContent {
                    Text(verbatim: "\(generator.emitted)")
                } label: {
                    Text(verbatim: "Events sent")
                }
            }
        } header: {
            Text(verbatim: "Traffic")
        }
    }
}
