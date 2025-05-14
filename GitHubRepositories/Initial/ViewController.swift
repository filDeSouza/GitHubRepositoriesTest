//
//  ViewController.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import UIKit

class ViewController<View: UIView>: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    var customView: View {
        return view as! View
    }

    override func loadView() {
        view = View()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let statusBarManager = view.window?.windowScene?.statusBarManager {
            let statusBarHeight = statusBarManager.statusBarFrame.height
            let statusBarView = UIView()
            statusBarView.backgroundColor = .black // Your color
            statusBarView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(statusBarView)
            NSLayoutConstraint.activate([
                statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
                statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                statusBarView.heightAnchor.constraint(equalToConstant: statusBarHeight)
            ])
        }
    }
}

