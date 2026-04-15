//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import StoreKit
import UIKit

@MainActor
func requestReview() {
    #if !DEBUG
        var count = UserDefaults.standard.integer(forKey: "request_review_count")
        count += 1
        UserDefaults.standard.set(count, forKey: "request_review_count")

        if count > 2 {
            Task {
                try! await Task.sleep(for: .seconds(5))

                if UIApplication.shared.applicationState == .active {
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as! UIWindowScene
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            }
        }
    #endif
}
