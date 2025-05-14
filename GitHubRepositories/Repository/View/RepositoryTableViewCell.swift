//
//  RepositoryTableViewCell.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation
import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    let pullRequestNameLabel = UILabel()
    let pullRequestDescriptionLabel = UILabel()
    let creationDateLabel = UILabel()
    let authorPictureImageView = UIImageView()
    let authorNameLabel = UILabel()
    
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
        pullRequestNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        pullRequestNameLabel.textColor = .blue
        pullRequestNameLabel.numberOfLines = 2
        pullRequestDescriptionLabel.font = .systemFont(ofSize: 12, weight: .light)
        pullRequestDescriptionLabel.numberOfLines = 2
        creationDateLabel.font = .systemFont(ofSize: 12, weight: .bold)
        creationDateLabel.numberOfLines = 1
        authorNameLabel.font = .systemFont(ofSize: 10, weight: .regular)
        authorNameLabel.textColor = .blue
        authorNameLabel.numberOfLines = 1
        authorNameLabel.textAlignment = .center
    }

    private func addSubviews() {
        addSubviews([pullRequestNameLabel, pullRequestDescriptionLabel, creationDateLabel, authorPictureImageView, authorNameLabel], constraints: true)
    }
 
    private func installConstraints() {
        pullRequestNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        pullRequestNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        pullRequestNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        pullRequestDescriptionLabel.topAnchor.constraint(equalTo: pullRequestNameLabel.bottomAnchor, constant: 8).isActive = true
        pullRequestDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        pullRequestDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        creationDateLabel.topAnchor.constraint(equalTo: pullRequestDescriptionLabel.bottomAnchor, constant: 12).isActive = true
        creationDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        creationDateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        authorPictureImageView.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: 20).isActive = true
        authorPictureImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        authorPictureImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        authorPictureImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        authorPictureImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        authorNameLabel.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: 10).isActive = true
        authorNameLabel.leftAnchor.constraint(equalTo: authorPictureImageView.rightAnchor, constant: 10).isActive = true
        authorNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    func configure(repositoriName: String, repositoriDescription: String, authorName: String, creationDate: String) {
        pullRequestNameLabel.text = repositoriName
        pullRequestDescriptionLabel.text = repositoriDescription
        creationDateLabel.text = "Data de criação: \(creationDate)"
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
        accessibilityLabel = "Nome do pull request: \(pullRequestNameLabel.text ?? "")\n, " + "Descrição do pull request: \(pullRequestDescriptionLabel.text ?? "")\n, " + "Data de criação do pull request: \(creationDateLabel.text ?? "")\n, " + "Nome do autor: \(authorNameLabel.text ?? "")"
        shouldGroupAccessibilityChildren = true

        pullRequestNameLabel.isAccessibilityElement = true
        pullRequestNameLabel.accessibilityLabel = "Nome do Pull request: \(pullRequestNameLabel.text ?? "")"
        pullRequestNameLabel.accessibilityIdentifier = "pullRequestNameLabel"

        pullRequestDescriptionLabel.isAccessibilityElement = true
        pullRequestDescriptionLabel.accessibilityLabel = "Descrição do Pull request: \(pullRequestDescriptionLabel.text ?? "")"
        pullRequestDescriptionLabel.accessibilityIdentifier = "pullRequestDescriptionLabel"
        
        creationDateLabel.isAccessibilityElement = true
        creationDateLabel.accessibilityLabel = "Data de criação: \(creationDateLabel.text ?? "")"
        creationDateLabel.accessibilityIdentifier = "pullRequestDescriptionLabel"

        authorPictureImageView.isAccessibilityElement = true
        authorPictureImageView.accessibilityLabel = "Avatar do autor"
        authorPictureImageView.accessibilityIdentifier = "authorPictureImageView"

        authorNameLabel.isAccessibilityElement = true
        authorNameLabel.accessibilityLabel = "Nome do autor: \(authorNameLabel.text ?? "")"
        authorNameLabel.accessibilityIdentifier = "authorNameLabel"
    }
}

