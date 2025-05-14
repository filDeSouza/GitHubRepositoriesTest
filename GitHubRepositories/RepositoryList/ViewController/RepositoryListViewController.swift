//
//  RepositoryListViewController.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 10/05/25.
//

import Foundation
import UIKit

final class RepositoryListViewController: ViewController<RepositoryListView> {
    
    let viewModel: RepositoryListViewModel
    
    init(viewModel: RepositoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = customView
        customView.tableView.accessibilityIdentifier = "RepositoryListTableView"

        setupNavBar()
        setupTableView()
        setupStates()
        customView.setupProgress(inProgress: true)
        viewModel.set(event: .loadRepositories)
    }
}

extension RepositoryListViewController {
    func setupStates() {
        
        viewModel.states
            .filter { $0.type == .showData }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.customView.setupFooterAnimation(animate: false)
                self.customView.tableView.reloadData()
                self.customView.setupProgress(inProgress: false)
            }).disposed(by: myDisposeBag)
        
        viewModel.states
            .filter { $0.type == .error }
            .map { model -> String? in model.getInfo() }
            .unwrap()
            .drive(onNext: { [weak self] error in
                self?.customView.setupProgress(inProgress: false)
                self?.layoutErrorView(text: error)
            }).disposed(by: myDisposeBag)
        
        viewModel.states
            .filter { $0.type == .scrollError }
            .map { model -> String? in model.getInfo() }
            .unwrap()
            .drive(onNext: { [weak self] error in
                self?.customView.setupFooterAnimation(animate: false)
                self?.customView.setupProgress(inProgress: false)
                self?.showToast(message: error.description, font: .systemFont(ofSize: 12.0))
            }).disposed(by: myDisposeBag)
    }
    
    private func layoutErrorView(text: String) {
        customView.errorView.subtitleLabel.text = text

        layoutErrorView(errorView: customView.errorView) { [viewModel] in
            viewModel.loadData.onNext(false)
        }

        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveLinear], animations: {
            self.customView.errorView.alpha = 1
        }, completion: nil)
    }
}

extension RepositoryListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0,
           (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height {
            customView.tableView.isSpringLoaded = true
            customView.setupFooterAnimation(animate: true)
            self.viewModel.set(event: .reloadRepositories(true))
        }
    }
    
    func setupTableView() {
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
    }
    
    func setupNavBar() {
        title = viewModel.viewTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
            ]
    }
}

extension RepositoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celula = tableView.dequeueReusableCell(withIdentifier: RepositoryListTableViewCell.description(), for: indexPath) as? RepositoryListTableViewCell else {
            return UITableViewCell()
        }
        let repository = viewModel.repositoriesList[indexPath.row]
        celula.configure(repositoriName: repository.name, repositoriDescription: repository.description, forksNumber: repository.forks_count.description, starsNumber: repository.stargazers_count.description, authorName: repository.owner.login)
        
        viewModel.setupImageData(imageURL: repository.owner.avatar_url) { data in
                if let data = data {
                    celula.updateAuthorImage(with: data)
                }
            }
                    
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.routes.drive(onNext: { nav in
            if case .openRepository = nav.type {
                print("openRepository triggered")
            }
        }).disposed(by: myDisposeBag)
        viewModel.set(event: .selectRepository(indexPath.row))
    }
    
}
