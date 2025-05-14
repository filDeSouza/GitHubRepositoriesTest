//
//  RepositoryViewControllerTests.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation
import XCTest
import Alamofire
@testable import GitHubRepositories

class RepositoryViewControllerTests: XCTestCase {
    var viewModel: RepositoryViewModel!
    var mockService: RepositoryServiceMock!
    var viewController: RepositoryViewController!

    override func setUp() {
        super.setUp()
        mockService = RepositoryServiceMock()
        viewModel = RepositoryViewModel(service: mockService, owner: "user", repo: "repo")
        viewController = RepositoryViewController(viewModel: viewModel)
        _ = viewController.view
    }

    func testViewDidLoad_setsTitleAndHeader() {
        XCTAssertEqual(viewController.title, viewModel.viewTitle)
        XCTAssertNotNil(viewController.customView.tableView.tableHeaderView)
    }

    func testTableView_showsPullsAfterServiceResponse() {
        mockService.pullListResult = [RepositoryPullModel.dummy]
        viewController.viewDidLoad()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
        let rows = viewController.tableView(viewController.customView.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 1)
    }

    func testErrorState_showsErrorView() {
        mockService.error = AFError.explicitlyCancelled
        viewController.viewDidLoad()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
        XCTAssertEqual(viewController.customView.errorView.alpha, 1, accuracy: 0.01)
    }

    func testEmptyResponse_showsToastOrHeader() {
        mockService.pullListResult = []
        viewController.viewDidLoad()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
    }
}
