//
//  RepositoryListUITests.swift
//  GitHubRepositoriesUITests
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation
import XCTest

class RepositoryListUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testRepositoryListLoads() {
        let table = app.tables["RepositoryListTableView"]
        let exists = NSPredicate(format: "exists == true")

        expectation(for: exists, evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAttachment(screenshot: app.screenshot())

        XCTAssertTrue(table.cells.count > 0, "Repository list should have at least one cell")
    }
}
