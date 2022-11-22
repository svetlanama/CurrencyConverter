//
//  NSError+Converter.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation

// MARK: - NSError
public enum ErrorType: Int {
    case unknown = 1
    case success = 200
    case created = 201
    case unready = 202
    case nocontent = 204
    case badrequest = 400
    case unauthorized = 401
    case permission = 403
    case notfound = 404
    
    
    func localizedUserInfo(description: Any?) -> [String: String] {
        var localizedDescription: String = ""
        let localizedFailureReasonError: String = ""
        let localizedRecoverySuggestionError: String = ""
        
        let comment = "Error.\(String(describing: self).capitalized)"
        
        if let data = description as? [String: Any], let detail = data["detail"] as? String {
            localizedDescription = NSLocalizedString(detail, comment: comment)
        } else {
            switch self {
            case .unknown:
                localizedDescription = NSLocalizedString("Unknown error", comment: comment)
            case .success:
                localizedDescription = NSLocalizedString("Success", comment: comment)
            case .created:
                localizedDescription = NSLocalizedString("Created", comment: comment)
            case .unready:
                localizedDescription = NSLocalizedString("Content not yet ready", comment: comment)
            case .nocontent:
                localizedDescription = NSLocalizedString("Success , No Content - Device Logged out", comment: comment)
            case .badrequest:
                localizedDescription = NSLocalizedString("Bad Request - Validation errors, missing parameters etc", comment: comment)
            case .unauthorized:
                localizedDescription = NSLocalizedString("Authentication Failed", comment: comment)
            case .permission:
                localizedDescription = NSLocalizedString("Permission Denied", comment: comment)
            case .notfound:
                localizedDescription = NSLocalizedString("Not Found", comment: comment)
            }
        }
        return [
            NSLocalizedDescriptionKey: localizedDescription,
            NSLocalizedFailureReasonErrorKey: localizedFailureReasonError,
            NSLocalizedRecoverySuggestionErrorKey: localizedRecoverySuggestionError
        ]
    }
}

public let ProjectErrorDomain = "ConverterErrorDomain"

extension NSError {
    
    public convenience init(type: ErrorType, description: Any?) {
        self.init(domain: ProjectErrorDomain, code: type.rawValue, userInfo: type.localizedUserInfo(description: description))
    }
}
