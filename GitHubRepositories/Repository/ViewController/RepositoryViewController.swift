//
//  RepositoryViewController.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation
import UIKit

final class RepositoryViewController: ViewController<RepositoryView> {
    
    let viewModel: RepositoryViewModel
    private let tableHeaderView = RepositoryTableHeaderView()
    
    init(viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = customView
        customView.tableView.tableHeaderView = tableHeaderView
        customView.tableView.accessibilityIdentifier = "RepositoryTableView"
        setupNavBar()
        setupTableView()
        setupStates()
        customView.setupProgress(inProgress: true)
        viewModel.set(event: .loadRepositories)
    }
}

extension RepositoryViewController {
    func setupStates() {
        
        viewModel.states
            .filter { $0.type == .showData }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.customView.tableView.reloadData()
                self.tableHeaderView.setupTexts(openedPulls: self.viewModel.openedPullText, closedPulls: self.viewModel.closedPullText)
                self.customView.tableView.updateTableHeaderViewHeight()
                self.customView.setupProgress(inProgress: false)
            }).disposed(by: myDisposeBag)
        
        viewModel.states
            .filter { $0.type == .responseEmpty }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.customView.setupProgress(inProgress: false)
                self.tableHeaderView.setupTexts(openedPulls: self.viewModel.openedPullText, closedPulls: self.viewModel.closedPullText)
                self.customView.tableView.updateTableHeaderViewHeight()
                self.showToast(message: self.viewModel.emptyResponseMessage, font: .systemFont(ofSize: 12.0))
            }).disposed(by: myDisposeBag)
        
        viewModel.states
            .filter { $0.type == .error }
            .map { model -> String? in model.getInfo() }
            .unwrap()
            .drive(onNext: { [weak self] error in
                self?.customView.setupProgress(inProgress: false)
                self?.layoutErrorView(text: error)
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

extension RepositoryViewController {
    
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

extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pullsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celula = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.description(), for: indexPath) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        let repository = viewModel.pullsList[indexPath.row]
        celula.configure(repositoriName: repository.title, repositoriDescription: repository.body ?? repository.head.repo.description, authorName: repository.user.login, creationDate: viewModel.setupDates(date: repository.created_at))
        
        viewModel.setupImageData(imageURL: repository.head.repo.owner.avatar_url) { data in
                if let data = data {
                    celula.updateAuthorImage(with: data)
                }
            }
                    
        return celula
    }
}

