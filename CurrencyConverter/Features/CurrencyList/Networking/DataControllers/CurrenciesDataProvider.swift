//
//  CurrenciesDataProvider.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 09/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

typealias CurrencyListRequestCompletion = (CurrencyListResponse?, Error?) -> Void

protocol CurrenciesDataProvider {

    /// Network Manager
    var networkManager: NetworkManager { get set }
    
    /// Initializes view model
    ///
    /// - Parameter networkManager: Responsible object for networking
    init(networkManager: NetworkManager)

    /// Retrieves exchange rates
    ///
    /// - Parameters:
    ///   - baseCurrency: The base currency
    ///   - completion: Completion block
    func retrieveExchangeRates(
        baseCurrency: String,
        completion: @escaping CurrencyListRequestCompletion)
}
