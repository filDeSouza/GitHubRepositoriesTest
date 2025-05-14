//
//  RepositoryViewModelTests.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation
import XCTest
import Alamofire
import RxSwift
@testable import GitHubRepositories


final class RepositoryViewModelTests: XCTestCase {
    var viewModel: RepositoryViewModel!
    var mockService: RepositoryServiceMock!
    
    override func setUp() {
        super.setUp()
        mockService = RepositoryServiceMock()
        viewModel = RepositoryViewModel(service: mockService, owner: "user", repo: "repo")
    }
    
    func testSetupPullsList_appendsNewItems() {
        viewModel.pullsList = [RepositoryPullModel.dummy]
        viewModel.setupPullsList(pullsListResponse: [RepositoryPullModel.dummy])
        XCTAssertEqual(viewModel.pullsList.count, 1)
        XCTAssertTrue(viewModel.pullsList.contains(where: { $0.id == 1 }))
    }
    
    func testSetupPullTexts_countsOpenedAndClosed() {
        viewModel.setupPullTexts(pulls: [RepositoryPullModel.dummy])
        XCTAssertEqual(viewModel.openedPullText, "1 opened")
        XCTAssertEqual(viewModel.closedPullText, "0 closed")
    }
    
    func testSetupImageData_invalidURL_returnsNil() {
        let expectation = self.expectation(description: "Completion called")
        viewModel.setupImageData(imageURL: "invalid_url") { data in
            XCTAssertNil(data)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
    }
    
    func testGetRepositoryPullData_successfulResponse() {
        let expectation = self.expectation(description: "Completion called")
        viewModel = RepositoryViewModel(service: mockService, owner: "user", repo: "repo")
        viewModel.getRepositoryPullData(service: mockService, owner: "user", repo: "repo", completion: { result in
            XCTAssertEqual(result?.count, 1)
            XCTAssertEqual(result?.first?.id, 1)
            expectation.fulfill()
        }, onError: { _ in
            XCTFail("Should not call onError")
        })
        waitForExpectations(timeout: 1)
    }
    
    func testGetRepositoryPullData_errorResponse() {
        mockService.error = AFError.explicitlyCancelled
        viewModel = RepositoryViewModel(service: mockService, owner: "user", repo: "repo")
        let expectation = self.expectation(description: "Error called")
        viewModel.getRepositoryPullData(service: mockService, owner: "user", repo: "repo", completion: { _ in
            XCTFail("Should not call completion")
        }, onError: { error in
            expectation.fulfill()
        })
        waitForExpectations(timeout: 1)
    }
}

