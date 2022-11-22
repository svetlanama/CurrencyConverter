//
//  API.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation
import Alamofire

enum API {
    
    case exchangeCurrencyCommercial(amount: Double, from: String, to: String)
    
    var method: HTTPMethod {
        switch self {
            case .exchangeCurrencyCommercial:
                return .get
        }
    }
    
    var url: String {
        
    #if DEBUG
            var baseUrl = "http://api.evp.lt"
    #else
    #if ALPHA
            var baseUrl = "http://api.evp.lt"
    #else
            var baseUrl = "http://api.evp.lt"
    #endif
    #endif
        
    switch self {
        case .exchangeCurrencyCommercial(let amount, let from, let to):
            return baseUrl + "/currency/commercial/exchange/\(amount.toString())-\(from)/\(to)/latest"
        }
    }
}
