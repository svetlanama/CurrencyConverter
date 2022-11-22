//
//  ValidationUtil.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 20.11.2022.
//

import Foundation

class ValidationUtil {
    
    static func isValidConvertion(sell: (balance: Balance?, amount: Double, commission: Double), receive: (balance: Balance?, amount: Double, commission: Double)) -> (valid: Bool, message: String) {
        
        if (sell.balance == nil || receive.balance == nil ) {
            return (false, "Please enter exchange values.")
        }
        
        if (sell.balance?.currency == receive.balance?.currency) {
            return (false, "Exchange currencies should not be equal.")
        }
        if (sell.amount.toInt() <= 0) {
            return (false, "Balance can't be negative after conversion.")
        }
        
        if ((sell.amount - sell.commission).toInt() <= 0) {
            return (false, "Balance can't be negative after conversion.")
        }
        
        if (receive.amount.toInt() <= 0) {
            return (false, "Please make sure you filled all exchange variables.")
        }
        
        return (true, "Validation passed successfully")
    }
}
