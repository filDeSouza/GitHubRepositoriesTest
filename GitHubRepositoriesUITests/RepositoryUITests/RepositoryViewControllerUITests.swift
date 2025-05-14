//
//  RepositoryViewControllerUITests.swift
//  GitHubRepositoriesUITests
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation
import XCTest

class RepositoryViewControllerUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testTableViewAppears() {
        let table = app.tables["RepositoryTableView"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(table.exists, "Table view should be visible")
    }

    func testTableViewHasCells() {
        let table = app.tables["RepositoryTableView"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(table.cells.count > 0, "Table view should have at least one cell")
    }
}
