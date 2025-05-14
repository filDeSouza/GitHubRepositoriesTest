//
//  RepositoryServiceTests.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 14/05/25.
//

import RxSwift
import RxCocoa
import Alamofire
@testable import GitHubRepositories

class RepositoryServiceMock: RepositoryServiceProtocol {
    var pullListResult: [RepositoryPullModel]?
    var error: AFError?
    
    func getPullList(user: String, repository: String, completion: @escaping ([RepositoryPullModel]?) -> Void, onError: @escaping (AFError) -> Void) {
        if let error = error {
            onError(error)
        } else {
            completion([RepositoryPullModel.dummy])
        }
    }
}

