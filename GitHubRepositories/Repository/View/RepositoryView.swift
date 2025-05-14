//
//  RepositoryView.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation
import UIKit
import ProgressHUD

final class RepositoryView: UIView {
    
    // MARK: - Views
    
    let contentView = UIView()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.description())
        return tableView
    }()
        
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
}

