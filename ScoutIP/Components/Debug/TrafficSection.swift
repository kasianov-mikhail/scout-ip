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
        Section("Traffic") {
            Toggle(
                "Simulated Traffic",
                isOn: Binding(get: { generator.isRunning }, set: { generator.toggle($0) })
            )

            if generator.isRunning {
                LabeledContent("Events sent", value: "\(generator.emitted)")
            }
        }
    }
}
