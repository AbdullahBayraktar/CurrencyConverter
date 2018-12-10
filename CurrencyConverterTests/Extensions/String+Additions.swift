//
//  String+Additions.swift
//  CurrencyConverterTests
//
//  Created by Abdullah Bayraktar on 10/12/2018.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

import XCTest
@testable import CurrencyConverter

final class StringTests: XCTestCase {

    func testIsValidDoubleBasicPositive() {
        let text = "0"
        XCTAssertTrue(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleBasicNegative() {
        let text = ""
        XCTAssertFalse(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleZero() {
        let text = "0.00"
        XCTAssertTrue(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleLongText() {
        let text = "120319248.00"
        XCTAssertTrue(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleContainingLetters() {
        let text = "2x234"
        XCTAssertFalse(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleTextWithoutDecimalPlaces() {
        let text = "1000"
        XCTAssertTrue(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleTextWithWrongDecimalPlaces() {
        let text = "1000.123"
        XCTAssertFalse(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleTextWithWrongCharacter() {
        let text = "1000:12"
        XCTAssertFalse(text.isValidDouble(maxDecimalPlaces: 2))
    }

    func testIsValidDoubleTextWithBigDecimalPlaces() {
        let text = "3.14257"
        XCTAssertTrue(text.isValidDouble(maxDecimalPlaces: 5))
    }
}

