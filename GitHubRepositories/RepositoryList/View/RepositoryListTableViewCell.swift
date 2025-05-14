//
//  RepositoryListTableViewCell.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import Foundation
import UIKit

class RepositoryListTableViewCell: UITableViewCell {
    
    let repositoriNameLabel = UILabel()
    let repositoriDescriptionLabel = UILabel()
    let forksNumberLabel = UILabel()
    let forkImage = UIImageView(image: UIImage(named: "git-fork")?.withTintColor(.orange))
    let starsNumberLabel = UILabel()
    let starImage = UIImageView(image: UIImage(named: "git-star")?.withTintColor(.orange))
    let authorPictureImageView = UIImageView()
    let authorNameLabel = UILabel()
    let numbersStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    let forksStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .fill
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return view
    }()
    let starsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .fill
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupImageSize()
        setupLabels()
        addSubviews()
        installConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorPictureImageView.layer.cornerRadius = authorPictureImageView.frame.width / 2
        authorPictureImageView.clipsToBounds = true
    }
    
    private func setupImageSize() {
        authorPictureImageView.contentMode = .scaleAspectFill
        authorPictureImageView.clipsToBounds = true
    }
    
    private func setupLabels() {
        repositoriNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        repositoriNameLabel.textColor = .blue
        repositoriDescriptionLabel.font = .systemFont(ofSize: 12, weight: .light)
        repositoriDescriptionLabel.numberOfLines = 2
        forksNumberLabel.font = .systemFont(ofSize: 13, weight: .bold)
        forksNumberLabel.textColor = .systemOrange
        starsNumberLabel.font = .systemFont(ofSize: 13, weight: .bold)
        starsNumberLabel.textColor = .systemOrange
        authorNameLabel.font = .systemFont(ofSize: 10, weight: .regular)
        authorNameLabel.textColor = .blue
        authorNameLabel.numberOfLines = 1
        authorNameLabel.textAlignment = .center
    }

    private func addSubviews() {
        forksStackView.addArrangedSubviews(views: [forkImage, forksNumberLabel])
        starsStackView.addArrangedSubviews(views: [starImage, starsNumberLabel])
        numbersStackView.addArrangedSubviews(views: [forksStackView, starsStackView])
        addSubviews([repositoriNameLabel, repositoriDescriptionLabel, numbersStackView, authorPictureImageView, authorNameLabel], constraints: true)
    }
 
    private func installConstraints() {
        repositoriNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        repositoriNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        repositoriDescriptionLabel.topAnchor.constraint(equalTo: repositoriNameLabel.bottomAnchor, constant: 8).isActive = true
        repositoriDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        repositoriDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -100).isActive = true
        
        numbersStackView.topAnchor.constraint(equalTo: repositoriDescriptionLabel.bottomAnchor, constant: 8).isActive = true
        numbersStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        numbersStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        authorPictureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        authorPictureImageView.leftAnchor.constraint(equalTo: repositoriNameLabel.rightAnchor, constant: 8).isActive = true
        authorPictureImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        authorPictureImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        authorPictureImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        authorNameLabel.topAnchor.constraint(equalTo: authorPictureImageView.bottomAnchor, constant: 8).isActive = true
        authorNameLabel.leftAnchor.constraint(equalTo: repositoriDescriptionLabel.rightAnchor, constant: 10).isActive = true
        authorNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        starsStackView.leftAnchor.constraint(equalTo: forksStackView.rightAnchor, constant: 10).isActive = true
        
        forkImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        forkImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        starImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func configure(repositoriName: String, repositoriDescription: String, forksNumber: String, starsNumber: String, authorName: String) {
        repositoriNameLabel.text = repositoriName
        repositoriDescriptionLabel.text = repositoriDescription
        forksNumberLabel.text = forksNumber
        starsNumberLabel.text = starsNumber
        authorNameLabel.text = authorName
        setupAccessibility()
    }
    
    func updateAuthorImage(with data: Data) {
        guard let image = UIImage(data: data) else { return }
        let targetSize = authorPictureImageView.bounds.size
        let resizedImage = resizeImage(image: image, targetSize: targetSize)
        self.authorPictureImageView.image = resizedImage
        setupImageSize()
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    private func setupAccessibility() {
        // Código deixado para acessibilidade da célula como um todo, para a acessibilidade por elemento, o valor de isAccessibilityElement deve ser deixado como false
        isAccessibilityElement = true
        accessibilityLabel = "Nome do repositório: \(repositoriNameLabel.text ?? "")\n, " + "Descrição: \(repositoriDescriptionLabel.text ?? "")\n, " + "Forks: \(forksNumberLabel.text ?? "")\n, " + "Stars: \(starsNumberLabel.text ?? "")\n, " + "Nome do autor: \(authorNameLabel.text ?? "")\n, " + "Botão"
        shouldGroupAccessibilityChildren = true

        repositoriNameLabel.isAccessibilityElement = true
        repositoriNameLabel.accessibilityLabel = "Nome do repositório: \(repositoriNameLabel.text ?? "")"
        repositoriNameLabel.accessibilityIdentifier = "repositoryNameLabel"

        repositoriDescriptionLabel.isAccessibilityElement = true
        repositoriDescriptionLabel.accessibilityLabel = "Descrição: \(repositoriDescriptionLabel.text ?? "")"
        repositoriDescriptionLabel.accessibilityIdentifier = "repositoryDescriptionLabel"

        forksNumberLabel.isAccessibilityElement = true
        forksNumberLabel.accessibilityLabel = "Forks: \(forksNumberLabel.text ?? "")"
        forksNumberLabel.accessibilityIdentifier = "forksNumberLabel"

        forkImage.isAccessibilityElement = true
        forkImage.accessibilityLabel = "Fork icon"
        forkImage.accessibilityIdentifier = "forkImageView"

        starsNumberLabel.isAccessibilityElement = true
        starsNumberLabel.accessibilityLabel = "Stars: \(starsNumberLabel.text ?? "")"
        starsNumberLabel.accessibilityIdentifier = "starsNumberLabel"

        starImage.isAccessibilityElement = true
        starImage.accessibilityLabel = "Star icon"
        starImage.accessibilityIdentifier = "starImageView"

        authorPictureImageView.isAccessibilityElement = true
        authorPictureImageView.accessibilityLabel = "Author picture"
        authorPictureImageView.accessibilityIdentifier = "authorPictureImageView"

        authorNameLabel.isAccessibilityElement = true
        authorNameLabel.accessibilityLabel = "Nome do autor: \(authorNameLabel.text ?? "")"
        authorNameLabel.accessibilityIdentifier = "authorNameLabel"
    }
}
