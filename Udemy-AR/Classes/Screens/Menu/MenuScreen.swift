//
//  ViewController.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import UIKit

class MenuScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    private let screenFactory = ScreenFactory()
    private let dataSet = ["World tracking", "Nodes", "Actions",
                           "External models", "Drawing", "Hit testing",
                           "Plane detection", "Scaling", "Vehicle",
                           "Measurements", "Portal", "Projectiles",
                           "Collisions", "Reflections"]
}

// MARK: - UITableViewDelegate
extension MenuScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let screen = screenFactory.screenFor(dataSet[indexPath.row]) else {
            return
        }

        navigationController?.pushViewController(screen, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MenuScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dataSet[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSet.count
    }
}
