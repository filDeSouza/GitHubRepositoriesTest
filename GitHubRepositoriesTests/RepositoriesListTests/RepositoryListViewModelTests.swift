//
//  RepositoryListViewModelTests.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 13/05/25.
//

import XCTest
import RxSwift
import RxCocoa
@testable import GitHubRepositories

class RepositoryListViewModelTests: XCTestCase {
    var viewModel: RepositoryListViewModel!
    var service: RepositoryListServiceMock!
    var disposeBag: DisposeBag!
    let navigationController = UINavigationController()
    var coordinator: MainCoordinator!

    override func setUp() {
        super.setUp()
        coordinator = MainCoordinator(navigationController: navigationController)
        service = RepositoryListServiceMock()
        viewModel = RepositoryListViewModel(service: service, coordinator: coordinator)
        disposeBag = DisposeBag()
    }

    func testLoadRepositoriesSuccess() {

        let expectation = self.expectation(description: "Should emit showData state")
        viewModel.states.drive(onNext: { nav in
            if case .showData = nav.type {
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)

        viewModel.loadData.onNext(false)

        waitForExpectations(timeout: 1)
        XCTAssertEqual(viewModel.repositoriesList.count, 2)
    }

    func testLoadRepositoriesError() {
        service.shouldReturnError = true
        service.error = .sessionDeinitialized

        let expectation = self.expectation(description: "Should emit error state")
        viewModel.states.drive(onNext: { nav in
            if case .error = nav.type {
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)

        viewModel.loadData.onNext(false)

        waitForExpectations(timeout: 1)
    }

    func testSetupRepositoryListAppendsUnique() {
        let repo1 = RepositoryListModel(id: 1, name: "Test", description: "Test description", forks_count: 10, stargazers_count: 1, owner: OwnerModel(login: "test", avatar_url: ""))
        let repo2 = RepositoryListModel(id: 2, name: "Test 2", description: "Test description 2", forks_count: 10, stargazers_count: 1, owner: OwnerModel(login: "test 2", avatar_url: ""))
        viewModel.repositoriesList = [repo1]

        viewModel.setupRepositoryList(repositoriesList: [repo1, repo2])

        XCTAssertEqual(viewModel.repositoriesList.count, 2)
        XCTAssertTrue(viewModel.repositoriesList.contains(where: { $0.id == 2 }))
    }
}
