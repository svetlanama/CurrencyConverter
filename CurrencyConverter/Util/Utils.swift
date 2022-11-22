//
//  Utils.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation

final class Utils {
    
    class func cutomError(code: Int, message: String) -> NSError {
        return NSError(domain: "com.currency.converter", code: code, userInfo: [NSLocalizedDescriptionKey : message])
    }
}
