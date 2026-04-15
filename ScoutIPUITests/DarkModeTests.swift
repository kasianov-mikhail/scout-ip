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
    app.launchArguments += ["-UITestMocking", "-UIUserInterfaceStyle", "Dark"]
  }

  @MainActor
  func testLaunchInDarkMode() {
    app.launch()

    XCTAssertTrue(app.tabBars.buttons["Info"].waitForExistence(timeout: 5))
    XCTAssertTrue(app.tabBars.buttons["History"].exists)
  }

  @MainActor
  func testTabNavigationInDarkMode() {
    app.launch()

    let historyTab = app.tabBars.buttons["History"]
    XCTAssertTrue(historyTab.waitForExistence(timeout: 5))
    historyTab.tap()
    XCTAssertTrue(app.navigationBars["History"].waitForExistence(timeout: 5))

    let infoTab = app.tabBars.buttons["Info"]
    infoTab.tap()
    XCTAssertTrue(app.navigationBars["Info"].waitForExistence(timeout: 5))
  }

  @MainActor
  func testSearchInDarkMode() {
    app.launch()

    let searchField = app.textFields["IP Search Field"]
    XCTAssertTrue(searchField.waitForExistence(timeout: 5))

    let searchButton = app.buttons["IP Search Button"]
    XCTAssertTrue(searchButton.exists)
  }
}
