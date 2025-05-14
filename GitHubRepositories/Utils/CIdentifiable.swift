//
//  CIdentifiable.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 14/05/25.
//

import Foundation
import UIKit

public protocol CIdentifiable {
    var accessibilityIdentifiers: [String]? { get }
    var uniqueAccessibilityIdentifiers: String? { get }

    func updateIdentifier(in view: UIView)
}

public extension CIdentifiable {
    var accessibilityIdentifiers: [String]? {
        return [String(describing: Self.self)]
    }

    func updateIdentifier(in view: UIView) {
        guard let identifiers = accessibilityIdentifiers else { return }

        view.accessibilityIdentifier = uniqueAccessibilityIdentifiers ?? identifiers
            .filter { $0.isNotEmpty }
            .unique()
            .joined(separator: " - ")
    }
}
