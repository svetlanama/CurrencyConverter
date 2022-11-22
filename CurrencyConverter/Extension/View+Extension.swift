//
//  View+Extension.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 20.11.2022.
//

import Foundation
import SwiftUI


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func displayStandardAlert(title: String, message: String){
        DispatchQueue.main.async {
            AlertUtil.showAlert(nil, title: title, message: message, buttons: ["Ok": nil])
        }
    }
}
#endif
