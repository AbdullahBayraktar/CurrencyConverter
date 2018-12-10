//
//  CurrencyListTableViewCell.swift
//  CurrencyConverter
//
//  Created by Abdullah Bayraktar on 02/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

final class CurrencyListTableViewCell: UITableViewCell {

    private enum Constant {
        static let minimumTextFieldWidth: CGFloat = 20
        static let maximumDecimalPlaces = 2
        static let maximumAmountCharacterLimit = 9
    }

    /// Outlets
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountTextFieldWidthConstraint: NSLayoutConstraint!

    /// Properties
    weak var delegate: CurrencyListTableViewCellDelegate?


    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    // MARK: - Views
    
    func configureCell(
        currency: Currency,
        delegate: CurrencyListTableViewCellDelegate?){

        currencyCodeLabel.text = currency.code
        amountTextField.text = currency.amount
        amountTextField.delegate = self
        customizeTextFieldSize(text: currency.amount)
        self.delegate = delegate
    }

    func updateCell(amount: String?) {
        amountTextField.text = amount ?? ""
        customizeTextFieldSize(text: amount)
    }

    // MARK: - Styling

    private func applyStyling(){
        selectionStyle = .none
        amountTextField.setBottomBorder(color: amountTextField.isFirstResponder ? .blue : .gray)
    }
}

// MARK: - Actions

private extension CurrencyListTableViewCell {

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.currencyListTableViewCell(self, editingChanged: sender.text)
    }

    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        delegate?.currencyListTableViewCell(self, editingDidBegin: sender.text)
    }
}

// MARK: - UITextFieldDelegate

extension CurrencyListTableViewCell: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {

        var shouldChangeCharacters = true

        let currentText = textField.text ?? ""
        let nsStringText = currentText as NSString
        let finalString = nsStringText.replacingCharacters(in: range, with: string)

        if string.isEmpty {
            customizeTextFieldSize(text: finalString)
            return shouldChangeCharacters
        }

        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        shouldChangeCharacters = replacementText.isValidDouble(maxDecimalPlaces: Constant.maximumDecimalPlaces) && finalString.count <= Constant.maximumAmountCharacterLimit

        if shouldChangeCharacters {
            customizeTextFieldSize(text: finalString)
        }

        return shouldChangeCharacters
    }
}


// MARK: - Helpers

extension CurrencyListTableViewCell {

    func customizeTextFieldSize(text: String?){
        let width = calculatedWidth(text : text ?? "")
        amountTextFieldWidthConstraint.constant = width < Constant.minimumTextFieldWidth ? Constant.minimumTextFieldWidth : width
        layoutIfNeeded()
    }

    func makeFirstResponder(){
        amountTextField.becomeFirstResponder()
        applyStyling()
    }

    func resignResponder(){
        amountTextField.resignFirstResponder()
        applyStyling()
    }

    func calculatedWidth(text: String) -> CGFloat{
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
}
