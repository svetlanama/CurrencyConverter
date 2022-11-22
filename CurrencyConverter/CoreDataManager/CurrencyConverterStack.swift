//
//  CurrencyConverterStack.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 17.11.2022.
//

import Foundation
import CoreData

func createCurrnecyConverterContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    let container = NSPersistentContainer(name: "CurrencyConverter")
    container.loadPersistentStores { _, error in
        guard error == nil else { fatalError("Failed to load store: \(error)") }
        DispatchQueue.main.async { completion(container) }
    }
}



