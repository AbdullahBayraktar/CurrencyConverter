//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 05/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

class Currency {

    /// Currency code
    var code: String?

    /// Amount
    var amount: String?

    /// Exchange rate of the currency
    var rate: Double?

    init(code: String?, amount: String?, rate: Double?) {
        self.code = code
        self.amount = amount
        self.rate = rate
    }
}
