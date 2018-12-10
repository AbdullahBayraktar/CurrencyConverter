//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 02/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

final class CurrencyListViewController: UIViewController {

    private enum Constant {
        static let currenciesUpdatePeriod = 1.0
    }

    /// Outlets
    @IBOutlet weak private var tableView: UITableView!

    /// View model
    var viewModel: CurrencyListViewModel!

    /// Service Timer
    var serviceTimer: Timer?

    // MARK: - Factory

    func initialize() {

        let networkManager = NetworkManager()
        let dataController = CurrenciesDataController(networkManager: networkManager)
        viewModel = CurrencyListViewModel(with: dataController)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        prepareViews()
        bindViewModel()

        scheduledTimer()
        viewModel.fetchCurrencyRates(isInitialFetch: true)
    }

    deinit {
        serviceTimer?.invalidate()
    }

    // MARK: - Fetch Data

    @objc func fetchCurrencyRates() {
        viewModel.fetchCurrencyRates(isInitialFetch: false)
    }
}

// MARK: Timer

private extension CurrencyListViewController {

    func scheduledTimer() {
        serviceTimer = Timer.scheduledTimer(
            timeInterval: Constant.currenciesUpdatePeriod,
            target: self,
            selector: #selector(fetchCurrencyRates),
            userInfo: nil,
            repeats: true)
    }
}
// MARK: - Views

private extension CurrencyListViewController {

    func prepareViews() {
        tableView.register(cellType: CurrencyListTableViewCell.self, bundle: nil)
        tableView.separatorStyle = .none
    }
}

// MARK: - Change Handler

private extension CurrencyListViewController {

    func bindViewModel() {
        viewModel.stateChangeHandler = { [unowned self] change in
            self.applyStateChange(change)
        }
    }

    func applyStateChange(_ change: CurrencyListState.Change) {

        switch change {
        case .initialFetch(let isInitialFetch):
            if isInitialFetch {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        case .amountsUpdate(let isUpdating):
            if !isUpdating {
                updateCellsAmountExceptSelectedCell()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.currenciesCount
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.className, for: indexPath) as! CurrencyListTableViewCell

        guard let currency = viewModel.currency(at: indexPath.row) else {
            return cell
        }

        cell.configureCell(currency: currency,
                           delegate: self)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as? CurrencyListTableViewCell
        cell?.makeFirstResponder()
        cellSelected(at: indexPath)
    }

    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CurrencyListTableViewCell
        cell?.resignResponder()
    }
}

// MARK: - TableView Helpers

private extension CurrencyListViewController {

    func cellSelected(at indexPath: IndexPath) {

        viewModel.moveToTopOfCurrencies(from: indexPath.row)

        tableView.beginUpdates()
        let topIndexPath = IndexPath(row: 0, section: 0)
        tableView.moveRow(at: indexPath, to: topIndexPath)
        tableView.endUpdates()
        tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
    }
}

// MARK: - CurrencyListTableViewCellDelegate

extension CurrencyListViewController: CurrencyListTableViewCellDelegate {

    func currencyListTableViewCell(
        _ sender: CurrencyListTableViewCell,
        editingChanged text: String?) {

        viewModel.updateAmount(
            amount: text,
            currencyCode:sender.currencyCodeLabel.text ?? "")
    }

    func currencyListTableViewCell(
        _ sender: CurrencyListTableViewCell,
        editingDidBegin text: String?) {
        
        viewModel.updateSelectedCurrency(
            amount: text,
            currencyCode: sender.currencyCodeLabel.text ?? "")
    }
}

// MARK: - TableView Helpers

extension CurrencyListViewController {

    func updateCellsAmountExceptSelectedCell() {

        DispatchQueue.main.async {
            guard let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows else {
                return
            }

            for indexPath in indexPathsForVisibleRows {
                let cell = self.tableView.cellForRow(at: indexPath) as? CurrencyListTableViewCell
                if cell?.currencyCodeLabel.text == self.viewModel.selectedCurrencyCode {
                    continue
                }

                if let currency = self.viewModel.currency(with: cell?.currencyCodeLabel.text) {
                    cell?.updateCell(amount: currency.amount)
                }
            }
        }
    }
}
