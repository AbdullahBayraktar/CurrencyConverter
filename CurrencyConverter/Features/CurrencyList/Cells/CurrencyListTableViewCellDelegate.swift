//
//  CurrencyListTableViewCellDelegate.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 04/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

protocol CurrencyListTableViewCellDelegate : class {

    /// Called when cell text is edited
    ///
    /// - Parameters:
    ///   - sender: TableViewCell
    ///   - editingChanged: Text after cell is text is edited
    func currencyListTableViewCell(_ sender: CurrencyListTableViewCell,
                                   editingChanged text: String?)

    /// Called when cell is selected
    ///
    /// - Parameters:
    ///   - sender: TableViewCell
    ///   - editingDidBegin: Text when cell is selected
    func currencyListTableViewCell(_ sender: CurrencyListTableViewCell,
                                   editingDidBegin text: String?)
}
