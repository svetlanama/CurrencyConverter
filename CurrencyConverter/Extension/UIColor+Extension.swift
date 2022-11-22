//
//  UIColor+Extension.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 22.11.2022.
//

import Foundation


import Foundation
import UIKit

extension UIColor {
    
    enum AppColor : Int {
        case havelockBlueApprox = 0x4197D4
    }

    convenience init(rgbValue: Int) {
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blue  = CGFloat(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    convenience init(named name: AppColor) {
        self.init(rgbValue: name.rawValue)
    }
}
