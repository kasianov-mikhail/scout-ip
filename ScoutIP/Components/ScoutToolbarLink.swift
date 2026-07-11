//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct ScoutToolbarLink: View {
    @Binding var isPresented: Bool

    private var isVisible: Bool {
        #if DEBUG
            return true
        #else
            return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        #endif
    }

    var body: some View {
        if isVisible {
            Button {
                isPresented = true
            } label: {
                Image(systemName: "chart.bar.xaxis")
            }
            .accessibilityLabel("Scout")
        }
    }
}
