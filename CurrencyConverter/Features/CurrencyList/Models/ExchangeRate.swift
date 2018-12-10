//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 03/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

struct ExchangeRate: Decodable {

    /// Currency code for the exchange rate
    var currencyCode: String

    /// Value of exchange rate
    var value: Double
}
