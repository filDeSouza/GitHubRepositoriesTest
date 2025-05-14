//
//  RepositoryListModel.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import Foundation

struct RepositoryListResponse: Decodable {
    let items: [RepositoryListModel]
}

struct RepositoryListModel: Decodable {
    let id: Int
    let name: String
    let description: String
    let forks_count: Int
    let stargazers_count: Int
    let owner: OwnerModel
}

struct OwnerModel: Decodable {
    let login: String
    let avatar_url: String
}
