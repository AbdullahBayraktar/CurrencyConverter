//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 02/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController {

    /// Outlets
    @IBOutlet weak private var tableView: UITableView!

    /// View model
    var viewModel: CurrencyListViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViews()
        // TODO: To be implemented
    }
}

// MARK: - Views

private extension CurrencyListViewController {

    func prepareViews() {
        tableView.register(cellType: CurrencyListTableViewCell.self, bundle: nil)
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDataSource

extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // FIXME: Get currencies count from view model
        return 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.className, for: indexPath)
        // TODO: To be implemented
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        // TODO: Handle cell selection
    }
}
