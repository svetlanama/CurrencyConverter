//
//  String+Extension.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 14.11.2022.
//

import Foundation

extension String {
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
