//
//  SettingsManager.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 18.11.2022.
//

import Foundation

class SettingsManager {
    static let sharedInstance = SettingsManager()
    
    private let defaults: UserDefaults
    private init() {
        defaults = UserDefaults.standard
    }
    
    var conversionsCount: Int {
        get {
            return defaults.integer(forKey: "conversions_count")
        }
        set {
            defaults.set(newValue, forKey: "conversions_count")
            defaults.synchronize()
        }
    }
    
    func resetConversionsCount() {
        conversionsCount = 0
    }
    
    func updateConversionsCount(count: Int) {
        conversionsCount = count
    }
    
    func increaseConversionsCount() {
        conversionsCount += 1
    }
}
