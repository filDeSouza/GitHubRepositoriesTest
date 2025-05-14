//
//  MainCoordinator.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 10/05/25.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = RepositoryListViewModel()
        let viewController = RepositoryListViewController(viewModel: viewModel)
        navigationController.navigationBar.backgroundColor = .black
        
        viewModel.routes
            .filter { $0.type == .openRepository }
            .map { model -> RepositoryListModel? in model.getInfo() }
            .unwrap()
            .drive(onNext: { [weak self] repositoryData in
                self?.openRepository(repositoryData: repositoryData)
            })
            .disposed(by: viewController.myDisposeBag)

        navigationController.show(viewController, sender: nil)
    }
    
    func openRepository(repositoryData: RepositoryListModel) {
        let viewModel = RepositoryViewModel(owner: repositoryData.owner.login, repo: repositoryData.name)
        let viewController = RepositoryViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
