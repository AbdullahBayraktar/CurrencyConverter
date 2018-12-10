//
//  CurrenciesDataController.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 09/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

final class CurrenciesDataController: CurrenciesDataProvider {
    
    var networkManager: NetworkManager

    required init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func retrieveExchangeRates(
        baseCurrency: String,
        completion: @escaping CurrencyListRequestCompletion) {

        var response: CurrencyListResponse?

        networkManager.sendRequest(baseCurrency: baseCurrency) { (data, error) in

            if error == nil,
                let jsonData = data {
                response = try? JSONDecoder().decode(CurrencyListResponse.self, from: jsonData)
            }
            completion(response, error)
        }
    }
}
