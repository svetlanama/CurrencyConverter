//
//  Double+Extension.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation

extension Double {
    func toString() -> String {
        return String(self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
    
    func format() -> String {
        return  String(format: "%.2f", self)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
