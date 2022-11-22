//
//  CommissionManager.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 20.11.2022.
//

import Foundation

final class CommissionManager {
    static let sharedInstance = CommissionManager()
    private let settingsManager  = SettingsManager.sharedInstance
    
    /*
     Commission is 0.7%
    */
    private var commission = 0.007
    private var freeConversions = 5
    
    private init() {
    }
    
    func getCommision() -> Double {
        if !isRequiresCommission() {
            return 0.0
        }
        return commission
    }
    
    func isRequiresCommission() -> Bool {
        return self.settingsManager.conversionsCount > freeConversions
    }
    
    func increaseConversionsCount() {
        settingsManager.increaseConversionsCount()
    }
}
