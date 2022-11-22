//
//  Balance.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 17.11.2022.
//

import Foundation
import CoreData

final class Balance: NSManagedObject, Identifiable {
    
    @NSManaged private(set) var order: Int16
    @NSManaged private(set) var currency: String
    @NSManaged private(set) var amount: Double
    
    @discardableResult
    static func insert(into context: NSManagedObjectContext, order: Int, currency: Currency, amount: Double) -> Balance? {
        
        var balance: Balance?
        balance = context.insertObject()
        
        balance?.order = order.toInt16()
        balance?.currency = currency.sign()
        balance?.amount = amount
        
        return balance
    }
    
    func update(amount: Double) {
        self.amount = amount
    }
}

extension Balance: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(order), ascending: true)]
    }
}
