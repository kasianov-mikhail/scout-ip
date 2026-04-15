//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import XCTest

final class ScoutIPUITests: XCTestCase {

  let app = XCUIApplication()

  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launchArguments += ["-UITestMocking"]
    app.launch()
  }

  // MARK: - Tabs

  @MainActor
  func testTabNavigation() {
    XCTAssertTrue(app.tabBars.buttons["Info"].waitForExistence(timeout: 5))
    XCTAssertTrue(app.tabBars.buttons["History"].exists)

    app.tabBars.buttons["History"].tap()
    XCTAssertTrue(app.navigationBars["History"].waitForExistence(timeout: 5))

    app.tabBars.buttons["Info"].tap()
    XCTAssertTrue(app.navigationBars["Info"].waitForExistence(timeout: 5))
  }

  // MARK: - Search

  @MainActor
  func testSearchFieldExists() {
    let searchField = app.textFields["IP Search Field"]
    XCTAssertTrue(searchField.waitForExistence(timeout: 5))
  }

  @MainActor
  func testSearchButtonExists() {
    let searchButton = app.buttons["IP Search Button"]
    XCTAssertTrue(searchButton.waitForExistence(timeout: 5))
  }

  @MainActor
  func testSearchMyIP() {
    let searchButton = app.buttons["IP Search Button"]
    searchButton.tap()

    XCTAssertTrue(app.cells.firstMatch.waitForExistence(timeout: 10))
  }

  @MainActor
  func testSearchSpecificIP() {
    let searchField = app.textFields["IP Search Field"]
    searchField.tap()
    searchField.typeText("8.8.8.8")

    let searchButton = app.buttons["IP Search Button"]
    searchButton.tap()

    XCTAssertTrue(app.cells.firstMatch.waitForExistence(timeout: 10))
  }

  // MARK: - History

  @MainActor
  func testHistoryShowsRecords() {
    app.buttons["IP Search Button"].tap()

    XCTAssertTrue(app.cells.firstMatch.waitForExistence(timeout: 10))

    app.tabBars.buttons["History"].tap()

    XCTAssertTrue(app.cells.firstMatch.waitForExistence(timeout: 10))
  }

  @MainActor
  func testHistoryFilterSegments() {
    app.tabBars.buttons["History"].tap()

    XCTAssertTrue(app.buttons["All"].waitForExistence(timeout: 5))
    XCTAssertTrue(app.buttons["User"].exists)
    XCTAssertTrue(app.buttons["Search"].exists)

    app.buttons["User"].tap()
    app.buttons["Search"].tap()
    app.buttons["All"].tap()
  }
}
