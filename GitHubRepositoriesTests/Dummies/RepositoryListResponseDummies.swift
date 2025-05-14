//
//  RepositoryListResponseDummies.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation

@testable import GitHubRepositories

extension RepositoryListResponse {
    static var dummy: RepositoryListResponse {
        return RepositoryListResponse(items: [RepositoryListModel(id: 1, name: "Test", description: "Test description", forks_count: 10, stargazers_count: 1, owner: OwnerModel(login: "test", avatar_url: "")),
                                              RepositoryListModel(id: 2, name: "Test 2", description: "Test description 2", forks_count: 10, stargazers_count: 1, owner: OwnerModel(login: "test 2", avatar_url: ""))])
    }
}
