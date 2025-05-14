//
//  Coordinator.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 10/05/25.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
