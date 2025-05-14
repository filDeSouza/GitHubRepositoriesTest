//
//  RepositoryPullsListModel.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation

struct RepositoryPullModel: Decodable {
    let title: String
    let id: Int
    let head: HeadModel
    let state: PullState
    let body: String?
    let created_at: Date
    let user: OwnerModel
    
    enum PullState: String, Codable, Equatable {
        case open = "open"
        case close = "close"
    }

}

struct HeadModel: Decodable {
    let repo: RepoModel
}

struct RepoModel: Decodable {
    let owner: OwnerModel
    let description: String
}
