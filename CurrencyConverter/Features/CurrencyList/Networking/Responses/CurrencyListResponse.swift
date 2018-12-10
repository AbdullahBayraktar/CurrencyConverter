//
//  CurrencyListResponse.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 02/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

struct CurrencyListResponse: Decodable {

    private enum CodingKeys: String, CodingKey {

        case baseCurrency = "base"
        case date = "date"
        case exchangeRates = "rates"
    }

    /// Base currency
    private(set) var baseCurrency: String

    /// date
    private(set) var date: String

    /// List of exchange rates
    private(set) var exchangeRates: [String: Double]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let baseCurrency = try container.decode(String.self, forKey: .baseCurrency)
        let date = try container.decode(String.self, forKey: .date)
        let exchangeRates = try container.decode([String: Double].self, forKey: .exchangeRates)

        self.baseCurrency = baseCurrency
        self.date = date
        self.exchangeRates = exchangeRates
    }
}
