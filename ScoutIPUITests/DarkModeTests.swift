//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import XCTest

final class DarkModeTests: XCTestCase {

  let app = XCUIApplication()

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  @MainActor
  func testLaunchInDarkMode() {
    app.launchArguments += ["-UIUserInterfaceStyle", "Dark"]
    app.launch()

    XCTAssertTrue(app.tabBars.buttons["InfoTab"].waitForExistence(timeout: 2))
    XCTAssertTrue(app.tabBars.buttons["HistoryTab"].exists)
  }

  @MainActor
  func testTabNavigationInDarkMode() {
    app.launchArguments += ["-UIUserInterfaceStyle", "Dark"]
    app.launch()

    app.tabBars.buttons["HistoryTab"].tap()
    XCTAssertTrue(app.navigationBars["HistoryTab"].waitForExistence(timeout: 2))

    app.tabBars.buttons["InfoTab"].tap()
    XCTAssertTrue(app.navigationBars["InfoTab"].waitForExistence(timeout: 2))
  }

  @MainActor
  func testSearchInDarkMode() {
    app.launchArguments += ["-UIUserInterfaceStyle", "Dark"]
    app.launch()

    let searchField = app.textFields["IP Search Field"]
    XCTAssertTrue(searchField.waitForExistence(timeout: 2))

    let searchButton = app.buttons["IP Search Button"]
    XCTAssertTrue(searchButton.exists)
  }
}