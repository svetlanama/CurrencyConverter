//
//  FormatterUtil.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 22.11.2022.
//

import Foundation


final class FormatterUtil {
    static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()

    static let numberFormatterSign: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.positivePrefix = "+"
        numberFormatter.negativePrefix = "-"
        return numberFormatter
    }()
}


