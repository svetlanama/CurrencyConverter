//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 14.11.2022.
//

import Foundation

enum Currency: String {
    case EUR
    case USD
    case JPY
    
    func sign() -> String {
        switch self {
        case .EUR:
            return "EUR"
        case .USD:
            return "USD"
        case .JPY:
            return "JPY"
        }
    }
}
