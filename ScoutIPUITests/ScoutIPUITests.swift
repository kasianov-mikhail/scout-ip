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
    XCTAssertTrue(app.tabBars.buttons["InfoTab"].exists)
    XCTAssertTrue(app.tabBars.buttons["HistoryTab"].exists)

    app.tabBars.buttons["HistoryTab"].tap()
    XCTAssertTrue(app.navigationBars["HistoryTab"].waitForExistence(timeout: 2))

    app.tabBars.buttons["InfoTab"].tap()
    XCTAssertTrue(app.navigationBars["InfoTab"].waitForExistence(timeout: 2))
  }

  // MARK: - Search

  @MainActor
  func testSearchFieldExists() {
    let searchField = app.textFields["IP Search Field"]
    XCTAssertTrue(searchField.waitForExistence(timeout: 2))
  }

  @MainActor
  func testSearchButtonExists() {
    let searchButton = app.buttons["IP Search Button"]
    XCTAssertTrue(searchButton.waitForExistence(timeout: 2))
  }

  @MainActor
  func testSearchMyIP() {
    let searchButton = app.buttons["IP Search Button"]
    searchButton.tap()

    let predicate = NSPredicate(format: "cells.count > 0")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: app.tables.firstMatch)
    wait(for: [expectation], timeout: 10)
  }

  @MainActor
  func testSearchSpecificIP() {
    let searchField = app.textFields["IP Search Field"]
    searchField.tap()
    searchField.typeText("8.8.8.8")

    let searchButton = app.buttons["IP Search Button"]
    searchButton.tap()

    let predicate = NSPredicate(format: "cells.count > 0")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: app.tables.firstMatch)
    wait(for: [expectation], timeout: 10)
  }

  // MARK: - History

  @MainActor
  func testHistoryShowsRecords() {
    // Search first to create a record
    app.buttons["IP Search Button"].tap()

    let predicate = NSPredicate(format: "cells.count > 0")
    let tableExpectation = XCTNSPredicateExpectation(
      predicate: predicate, object: app.tables.firstMatch)
    wait(for: [tableExpectation], timeout: 10)

    // Switch to History
    app.tabBars.buttons["HistoryTab"].tap()

    let historyPredicate = NSPredicate(format: "cells.count > 0")
    let historyExpectation = XCTNSPredicateExpectation(
      predicate: historyPredicate, object: app.tables.firstMatch)
    wait(for: [historyExpectation], timeout: 5)
  }

  @MainActor
  func testHistoryFilterSegments() {
    app.tabBars.buttons["HistoryTab"].tap()

    XCTAssertTrue(app.buttons["all"].waitForExistence(timeout: 2))
    XCTAssertTrue(app.buttons["user"].exists)
    XCTAssertTrue(app.buttons["search"].exists)

    app.buttons["user"].tap()
    app.buttons["search"].tap()
    app.buttons["all"].tap()
  }

  // MARK: - Launch Performance

  @MainActor
  func testLaunchPerformance() throws {
    measure(metrics: [XCTApplicationLaunchMetric()]) {
      XCUIApplication().launch()
    }
  }
}