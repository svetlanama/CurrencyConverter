//
//  AlertUtil.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 14.11.2022.
//

import Foundation
import UIKit

class AlertUtil {
    
    typealias ButtonConfigure = (action: ((UIAlertAction) -> Void)?, style: UIAlertAction.Style)
    typealias AlertButtons = [String: ButtonConfigure]
    
    class func showAlert(_ targetVC: UIViewController?, title: String?, message: String?, buttons: [String: ((UIAlertAction) -> Void)?]) {
        
        var dict = AlertButtons()
        buttons.forEach { (key, value) in
            dict[key] = ButtonConfigure(value, style: .default)
        }
        
        showAlert(targetVC, title: title, message: message, buttons: dict)
    }
    
    class func showAlert(_ targetVC: UIViewController?, title: String?, message: String?, buttons: AlertButtons) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        for (title, handler) in buttons {
            let alertButton = UIAlertAction(
                title: title,
                style: handler.style,
                handler: handler.action)
            
            alert.addAction(alertButton)
        }
        
        if (targetVC == nil) {
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            targetVC!.present(alert, animated: true, completion: nil)
        }
    }
}
