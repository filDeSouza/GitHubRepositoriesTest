//
//  RepositoryListViewControllerTests.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation
import XCTest
@testable import GitHubRepositories

final class RepositoryListViewControllerTests: XCTestCase {
    var viewModel: RepositoryListViewModel!
    var viewController: RepositoryListViewController!
    let navigationController = UINavigationController()
    var coordinator: MainCoordinator!
    var service: RepositoryListServiceMock!

    override func setUp() {
        super.setUp()
        coordinator = MainCoordinator(navigationController: navigationController)
        service = RepositoryListServiceMock()
        viewModel = RepositoryListViewModel(service: service, coordinator: coordinator)
        viewController = RepositoryListViewController(viewModel: viewModel)
        _ = viewController.view
    }

    func testViewDidLoad_setsUpTableView() {
        XCTAssertNotNil(viewController.customView.tableView.dataSource)
        XCTAssertNotNil(viewController.customView.tableView.delegate)
    }

    func testTableViewNumberOfRows_matchesRepositoriesCount() {
        let tableView = viewController.customView.tableView
        let rows = viewController.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, viewModel.repositoriesList.count)
    }

    func testCellForRowAt_configuresCell() {
        let tableView = viewController.customView.tableView
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = viewController.tableView(tableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell is RepositoryListTableViewCell)
    }
}
