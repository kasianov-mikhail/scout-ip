//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct StarListButton: View {
    @Binding var isStarred: Bool

    private let tracker = HistoryActionTracker()

    var body: some View {
        Button {
            isStarred.toggle()
            tracker.favoriteFilterToggled(isStarred)
        } label: {
            Image(systemName: "list.star")
        }
        .buttonStyle(.plain)
        .foregroundColor(isStarred ? .blue : .secondary)
    }
}
