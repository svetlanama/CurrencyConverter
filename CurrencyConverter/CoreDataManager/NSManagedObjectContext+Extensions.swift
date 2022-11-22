//
//  NSManagedObjectContext+Extensions.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 17.11.2022.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    @discardableResult
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            return false
        }

    }
    
    func performChanges() async {
        if self.hasChanges {
            await perform {
                self.saveOrRollback()
            }
        }
    }
}
