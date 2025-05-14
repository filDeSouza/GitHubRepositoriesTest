//
//  RepositoryPullModelDummies.swift
//  GitHubRepositoriesTests
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation

@testable import GitHubRepositories

extension RepositoryPullModel {
    static var dummy: RepositoryPullModel {
        return RepositoryPullModel(title: "Teste", id: 1, head: HeadModel(repo: RepoModel(owner: OwnerModel(login: "Tester 1",
                                                                                                            avatar_url: ""),
                                                                                          description: "Description test 1")), state: .open, body: "Teste body", created_at: "2025-07-03".date(format: "yyyy-MM-dd")!, user: OwnerModel(login: "Tester 1",
                                                                                                                                                                                                           avatar_url: ""))
    }
}
