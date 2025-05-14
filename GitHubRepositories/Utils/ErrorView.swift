//
//  ErrorView.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 13/05/25.
//

import Foundation
import UIKit

public typealias ActionVoid = (() -> Void)

public class ErrorView: UIView {
    public let titleLabel = UILabel()

    public let subtitleLabel = UILabel()

    public let button = UIButton(type: .system)

    private let contentView = UIView()

    public var buttonAction: ActionVoid?

    @discardableResult public convenience init(title: String? = nil, subtitle: String?, inView: UIView?, buttonAction: ActionVoid?) {
        self.init()
        self.buttonAction = buttonAction

        titleLabel.text = title
        subtitleLabel.text = subtitle

        if let inView = inView {
            inView.addSubview(self, constraints: true)
            center(to: inView)
        }

        if buttonAction == nil {
            button.isHidden = true
        }
    }

    override private init(frame: CGRect) {
        super.init(frame: frame)

        createSubviews()
        createConstraints()
        createBinds()
    }

    public init() {
        super.init(frame: .zero)

        setupValues()
        createSubviews()
        createConstraints()
        createBinds()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupValues() {
        titleLabel.text = "Algo deu errado"

        subtitleLabel.text = "Não foi possível carregar\nas informações."
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byTruncatingTail

        button.setTitle("Tentar novamente", for: .normal)
    }

    func createSubviews() {
        contentView.addSubviews([titleLabel, subtitleLabel, button], constraints: true)
        addSubview(contentView, constraints: true)
    }

    func createConstraints() {
        let dict: [String: Any] = [
            "title": titleLabel,
            "sub": subtitleLabel,
            "btn": button,
            "cont": contentView
        ]

        activateConstraints("V:|-13-[title]-12-[sub]-4-[btn]|", views: dict)

        [titleLabel, subtitleLabel, button].forEach {
            activateConstraints("H:|->=0-[v]->=0-|", views: ["v": $0])
            $0.centerX(to: self)
        }

        activateConstraints("V:|->=0-[cont]->=0-|", views: dict)
        activateConstraints("H:|->=0-[cont(<=220)]->=0-|", views: dict)
        contentView.center(to: self)
    }

    func createBinds() {
        button.addTarget(self, action: #selector(tappedButton), for: UIControl.Event.touchUpInside)
    }

    @objc func tappedButton() {
        buttonAction?()
        removeFromSuperview()
    }
}
