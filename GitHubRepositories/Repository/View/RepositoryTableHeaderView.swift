//
//  RepositoryTableHeaderView.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation
import RxCocoa
import UIKit

// MARK: Class

final class RepositoryTableHeaderView: UIView {
    let numbersStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        return view
    }()
    let openedPullsLabel = UILabel()
    let closedPullsLabel = UILabel()
    let separatorLabel = UILabel()

    public init() {
        super.init(frame: .zero)

        setupLabels()
        addSubviews()
        installConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        return nil
    }

    private func addSubviews() {
        numbersStackView.addArrangedSubviews(views: [openedPullsLabel, separatorLabel, closedPullsLabel])
        addSubview(numbersStackView, constraints: true)
    }

    private func installConstraints() {
        numbersStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        numbersStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        numbersStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        numbersStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupLabels() {
        openedPullsLabel.font = .systemFont(ofSize: 13, weight: .bold)
        openedPullsLabel.textColor = .systemOrange
        separatorLabel.font = .systemFont(ofSize: 13, weight: .bold)
        separatorLabel.textColor = .black
        separatorLabel.text = "/"
        separatorLabel.textAlignment = .center
        closedPullsLabel.font = .systemFont(ofSize: 13, weight: .bold)
        closedPullsLabel.textColor = .black
        
    }
    
    func setupTexts(openedPulls: String, closedPulls: String) {
        openedPullsLabel.text = openedPulls
        openedPullsLabel.textAlignment = .right
        closedPullsLabel.text = closedPulls
        closedPullsLabel.textAlignment = .left
    }
}
