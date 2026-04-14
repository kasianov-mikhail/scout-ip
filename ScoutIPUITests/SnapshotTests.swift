//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import XCTest

final class SnapshotTests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    @MainActor
    func testInfoScreenSnapshot() {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Info Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testHistoryScreenSnapshot() {
        app.tabBars.buttons["History"].tap()

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "History Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testInfoScreenDarkModeSnapshot() {
        app.terminate()
        app.launchArguments += ["-UIUserInterfaceStyle", "Dark"]
        app.launch()

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Info Screen - Dark Mode"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testHistoryScreenDarkModeSnapshot() {
        app.terminate()
        app.launchArguments += ["-UIUserInterfaceStyle", "Dark"]
        app.launch()

        app.tabBars.buttons["History"].tap()

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "History Screen - Dark Mode"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
