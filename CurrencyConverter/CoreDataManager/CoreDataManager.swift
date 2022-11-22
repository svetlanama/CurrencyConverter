//
//  CoreDataManager.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 17.11.2022.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let sharedInstance = CoreDataManager()
    
    fileprivate var mainContext: NSManagedObjectContext!
    fileprivate var privateContext: NSManagedObjectContext!
    fileprivate var token: NSObjectProtocol?
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        return container
    }()
    
    
    private init() {
        self.mainContext = persistentContainer.viewContext
        self.privateContext = persistentContainer.newBackgroundContext()
        privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func createCuncurrentContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}

extension CoreDataManager {
    func initBalance(data: [(currency: Currency, amount: Double)]) async {
        await privateContext.perform {
            for (index, item) in data.enumerated() {
                _ = Balance.insert(into: self.privateContext, order: index + 1, currency: item.currency, amount: item.amount)
            }
        }
        await privateContext.performChanges()
    }
    
    func saveBalance(order: Int, currency: Currency, amount: Double) async {
        await privateContext.perform {
            _ = Balance.insert(into: self.privateContext, order: order, currency: currency, amount: amount)
        }
        await privateContext.performChanges()
    }
    
    func updateBalance(balance: Balance?, amount: Double, completion: (() -> ())? = nil) async {
        await privateContext.perform {
            _ = balance?.update(amount: amount)
        }
        await privateContext.performChanges()
    }
    
    func getBalance() async -> [Balance] {
        var balance: [Balance] = []
        await privateContext.perform {
            let request = Balance.sortedFetchRequest
            request.returnsObjectsAsFaults = false
            balance = try! self.privateContext.fetch(request)
        }
        return balance
    }
}


extension CoreDataManager {
    
    func saveContext () async {
        await privateContext.performChanges()
    }
    
    func clearAllData()  async {
        await self.privateContext.perform {
            self.token = self.privateContext.addObjectsDidChangeNotificationObserver { [weak self] note in
                print("note.deletedObjects.count: \(note.deletedObjects.count) ")
                guard note.deletedObjects.count > 0 else { return }
                print("note.getNotification(): \(note.getNotification()) ")
                self?.privateContext.mergeChanges(fromContextDidSave: note.getNotification())
            }
        }
        
        await  self.clearAllEntitiesByName("Balance", context: self.privateContext)
        
        await self.privateContext.performChanges()
        if let _token = self.token {
            NotificationCenter.default.removeObserver(_token)
            self.token = nil
        }
    }
    
    func clearAllEntitiesByName(_ name: String, context: NSManagedObjectContext) async {
        await persistentContainer.performBackgroundTask { privateManagedObjectContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            deleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let result = try privateManagedObjectContext.execute(deleteRequest) as? NSBatchDeleteResult
                
                // Retrieves the IDs deleted
                guard let objectIDs = result?.result as? [NSManagedObjectID] else { return }
                
                // Updates the private context
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.privateContext])
            }
            catch let error as NSError {
                print("ClearAllEntitiesByName error: ", error)
            }
        }
    }
}
