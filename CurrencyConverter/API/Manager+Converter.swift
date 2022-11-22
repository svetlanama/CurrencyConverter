//
//  Manager+Converter.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation
import Alamofire

class SessionManager {
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpShouldSetCookies = false
    }
    
    private func getHeader(accessToken: String! = nil) -> HTTPHeaders? {
        var header: HTTPHeaders?
        
        header = ["Accept": "application/json"]
        if let token = accessToken {
            header?["Authorization"] = "Bearer " + token
        }
        
        return header
    }
    
    func apiRequest(api: API, parameters: [String : Any]? = nil, accessToken: String! = nil) -> DataRequest {
        let headers = getHeader(accessToken: accessToken)
        return AF.request(api.url, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
}
