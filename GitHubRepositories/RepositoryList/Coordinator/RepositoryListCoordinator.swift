//
//  RepositoryListCoordinator.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 11/05/25.
//

import Foundation

class RepositoryListCoordinator {
    private let coordinator: MainCoordinator
    private let viewModel: RepositoryListViewModel
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.viewModel = RepositoryListViewModel(coordinator: coordinator)
    }
    
    func start() {
        let viewController = RepositoryListViewController(viewModel: viewModel)
        
        viewModel.routes
            .filter { $0.type == .openRepository }
            .map { model -> RepositoryListModel? in model.getInfo() }
            .unwrap()
            .drive(onNext: { [coordinator] repositoryData in
                coordinator.openRepository(repositoryData: repositoryData)
            })
            .disposed(by: viewController.myDisposeBag)
        
    }
}
