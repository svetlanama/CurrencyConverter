//
//  DataRequest+Converter.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation
import Alamofire

struct ConvertCurrencyResponse: Decodable {
    let amount: String
    let currency: String
}
