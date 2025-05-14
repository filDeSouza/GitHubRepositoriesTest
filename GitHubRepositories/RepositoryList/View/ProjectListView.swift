//
//  RepositoryListView.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import Foundation
import UIKit
import ProgressHUD

final class RepositoryListView: UIView {
    
    // MARK: - Views
    
    let contentView = UIView()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: RepositoryListTableViewCell.description())
        return tableView
    }()
    
    private let footerActivityIndicator = UIActivityIndicatorView(style: .medium)
    
    let errorView = ErrorView()
        
    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        installConstraints()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubviews([contentView], constraints: true)

        contentView.addSubview(tableView, constraints: true)
    }
    
    func setupProgress(inProgress: Bool) {
        if inProgress {
            ProgressHUD.animate()
        } else {
            ProgressHUD.dismiss()
        }
    }
    
    private func installConstraints() {
        contentView.anchors(equalTo: self)
        tableView.anchors(equalTo: contentView)
    }
    
    func setupFooterAnimation(animate: Bool) {
        if animate {
            footerActivityIndicator.startAnimating()
            footerActivityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
            tableView.tableFooterView = footerActivityIndicator
        } else {
            footerActivityIndicator.stopAnimating()
        }
    }
}
