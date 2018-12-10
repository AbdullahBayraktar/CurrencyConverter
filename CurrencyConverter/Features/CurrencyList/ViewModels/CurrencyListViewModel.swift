//
//  CurrencyListViewModel.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 03/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

typealias CurrencyListFetchCompletion = (Bool) -> Void

final class CurrencyListState {

    enum Change {
        case initialFetch(Bool)
        case amountsUpdate(Bool)
    }

    /// Triggered when change occured
    var onChange: ((CurrencyListState.Change) -> Void)?

    /// Initial fetch state
    fileprivate(set) var isInitialFetch: Bool = false {
        didSet { onChange?(.initialFetch(isInitialFetch)) }
    }

    /// Amounts update state
    fileprivate(set) var isUpdating: Bool = false {
        didSet { onChange?(.amountsUpdate(isUpdating)) }
    }
}

final class CurrencyListViewModel {

    /// State
    private let state = CurrencyListState()

    /// State change handler to trigger
    var stateChangeHandler: ((CurrencyListState.Change) -> Void)? {
        get { return state.onChange }
        set { state.onChange = newValue }
    }

    // Data provider
    private var dataProvider: CurrenciesDataProvider

    /// Count of the currencies in currency list
    var currenciesCount: Int {
        return currencies?.count ?? 0
    }

    /// Amount entered by user
    var enteredAmount: Double = 0

    /// Currency code for the selected item
    var selectedCurrencyCode: String = "EUR"

    /// List of currencies
    var currencies: [Currency]?

    /// Initializes a new view model
    ///
    /// - Parameter dataProvider: Provided data provider
    init(with dataProvider: CurrenciesDataProvider) {
        self.dataProvider = dataProvider
    }
}

// MARK: - Currency accessers

extension CurrencyListViewModel {

    /// Returns currency at given index
    ///
    /// - Parameter index: Index of the requested currency
    /// - Returns: Currency if exists
    func currency(at index: Int) -> Currency? {
        guard index < currenciesCount,
            let currencies = currencies else { return nil }

        return currencies[index]
    }

    /// Returns currency with currency code
    ///
    /// - Parameter code: currency code
    /// - Returns: Currency if exists
    func currency(with code: String?) -> Currency? {
        guard let code = code,
            let currencies = currencies else { return nil }

        for currency in currencies {
            if code == currency.code {
                return currency
            }
        }
        return nil
    }
}

// MARK: - Update Amounts

extension CurrencyListViewModel {

    /// Updates amounts for other currencies for given amount
    ///
    /// - Parameters
    ///   - amount: Amount
    ///   - currencyCode: Currency code
    func updateAmount(amount: String?, currencyCode: String) {
        if let amount = amount {
            enteredAmount = Double(amount) ?? 0
            calculateConvertedAmountsForEnteredAmount()
        }
    }

    /// Updates selected currency and amount
    ///
    /// - Parameters
    ///   - amount: Amount
    ///   - currencyCode: Currency code
    func updateSelectedCurrency(amount: String?, currencyCode: String) {
        if let amount = amount {
            enteredAmount = Double(amount) ?? 0
            selectedCurrencyCode = currencyCode
        }
    }

    /// Moves current item to the top of currenices list
    ///
    /// - Parameter index: Index for the selected cell
    func moveToTopOfCurrencies(from index: Int) {

        var currentCurrencies = currencies ?? []
        let element = currentCurrencies.remove(at: index)
        currentCurrencies.insert(element, at: 0)
        currencies = currentCurrencies

        fetchCurrencyRates(isInitialFetch: false)
    }
}

// MARK: - Amount Calculations

private extension CurrencyListViewModel {

    /// Calculates amounts
    func calculateConvertedAmountsForEnteredAmount() {
        guard let currencies = currencies else { return }

        var updatedAmounts: [Currency] = []
        for currency in currencies {
            let amountDouble = enteredAmount * (currency.rate ?? 0)
            currency.amount = amountDouble == 0 ? "" : String(format: "%.2f", amountDouble)
            updatedAmounts.append(currency)
        }

        self.currencies = updatedAmounts
        state.isUpdating = false
    }
}

// MARK: - Network

extension CurrencyListViewModel {

    /// Fetch currencies along with exchange rates
    ///
    /// - Parameter isInitialFetch: Flag to determine if it is initial fetch
    func fetchCurrencyRates(isInitialFetch: Bool) {
        let baseCurrency = selectedCurrencyCode

        state.isUpdating = true
        dataProvider.retrieveExchangeRates(
            baseCurrency: baseCurrency, completion: { [weak self] (response, error) in

                guard let strongSelf = self else { return }

                if error == nil,
                    let exchangeRatesDictionary = response?.exchangeRates {

                    if isInitialFetch {
                        var retrievedCurrencies: [Currency] = []
                        for (key, value) in exchangeRatesDictionary {
                            let currency = Currency(code: key, amount: nil, rate: value)
                            retrievedCurrencies.append(currency)
                        }
                        // Add base currency
                        let baseCurrency = Currency(code: baseCurrency, amount: nil, rate: nil)
                        retrievedCurrencies.insert(baseCurrency, at: 0)

                        strongSelf.currencies = retrievedCurrencies
                    } else {
                        for (key, value) in exchangeRatesDictionary {
                            strongSelf.currencies?.filter({$0.code == key}).forEach {
                                $0.rate = value
                            }
                        }
                    }

                    strongSelf.calculateConvertedAmountsForEnteredAmount()
                    strongSelf.state.isInitialFetch = isInitialFetch
                }
        })
    }
}
