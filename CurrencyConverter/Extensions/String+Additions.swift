//
//  String+Additions.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 07/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

extension String {

    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        let decimalSeparator = formatter.decimalSeparator ?? "."

        if formatter.number(from: self) != nil {
            let split = self.components(separatedBy: decimalSeparator)
            let digits = split.count == 2 ? split.last ?? "" : ""
            return digits.count <= maxDecimalPlaces
        }
        return false
    }
}
