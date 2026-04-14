//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Metrics
import SwiftUI

struct MetricsSection: View {
  @State private var count = 0

  var body: some View {
    Section("Metrics") {
      Button("Increment counter") {
        Counter(label: "debug_counter").increment()
        count += 1
      }

      Button("Record timer (1s)") {
        Timer(label: "debug_timer").recordSeconds(1.0)
        count += 1
      }

      Text("Recorded: \(count) metrics")
        .foregroundStyle(.secondary)
    }
  }
}
