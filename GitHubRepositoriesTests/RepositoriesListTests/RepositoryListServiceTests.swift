//
//  RepositoryListServiceTests.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 13/05/25.
//

import RxSwift
import RxCocoa
import Alamofire
@testable import GitHubRepositories

class RepositoryListServiceMock: RepositoryListServiceProtocol {
    var shouldReturnError = false
    var error: AFError = .explicitlyCancelled

    func getProjectList(page: Int, completion: @escaping (RepositoryListResponse?) -> Void, onError: @escaping (AFError) -> Void) {
        if shouldReturnError {
            onError(error)
        } else {
            completion(RepositoryListResponse.dummy)
        }
    }
}
