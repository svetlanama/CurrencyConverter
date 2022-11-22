//
//  APIService.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation
import Alamofire
import PromiseKit

class APIService {
    
    static let sharedInstance = APIService()
    private var manager: SessionManager
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpShouldSetCookies = false
        manager = SessionManager()
    }
    
    @discardableResult
    func exchange(amount: Double, from: String, to: String) async -> Any {
        let dataTask =  manager.apiRequest(api: .exchangeCurrencyCommercial(amount: amount, from: from, to: to)).serializingDecodable(ConvertCurrencyResponse.self)
        
        let response = await dataTask.response
        switch response.result {
        case .success(let data):
            return data
        case .failure(let error):
            return error
        }
    }
    
}
