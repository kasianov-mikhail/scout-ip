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

    XCTAssertTrue(app.tabBars.buttons["Info"].waitForExistence(timeout: 2))
    XCTAssertTrue(app.tabBars.buttons["History"].exists)
  }

  @MainActor
  func testTabNavigationInDarkMode() {
    app.launchArguments += ["-UIUserInterfaceStyle", "Dark"]
    app.launch()

    app.tabBars.buttons["History"].tap()
    XCTAssertTrue(app.navigationBars["History"].waitForExistence(timeout: 2))

    app.tabBars.buttons["Info"].tap()
    XCTAssertTrue(app.navigationBars["Info"].waitForExistence(timeout: 2))
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
