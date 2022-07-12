//
//  PersistenceManager.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import CoreData

public class PersistenceManager {
    public static let shared = PersistenceManager()
    
    let persistentContainer: NSPersistentContainer
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Initializer
    init(persistentContainer: NSPersistentContainer = NSPersistentContainer.main) {
        self.persistentContainer = persistentContainer
    }
}

// MARK: - PersistenceManagerInterface
extension PersistenceManager: PersistenceManagerInterface {
    func save() throws {
        do {
            try managedObjectContext.save()
        } catch {
            rollback()
            throw PersistenceManagerError.operationFailed
        }
    }
    
    func rollback() {
        managedObjectContext.rollback()
    }
    
    func createPost(userId: Int32,
                    id: Int32,
                    title: String,
                    body: String) throws {
        let newPost = PostCDEntity(context: managedObjectContext)
        newPost.userId = userId
        newPost.id = id
        newPost.title = title
        newPost.body = body
        
        try save()
    }
    
//    public func createCounter(id: String,
//                       title: String,
//                       count: Int) throws {
//        let newCounterEntity = CounterEntity(context: managedObjectContext)
//        newCounterEntity.id = id
//        newCounterEntity.title = title
//        newCounterEntity.count = Int32(count)
//        newCounterEntity.synched = true
//        
//        try save()
//    }
//    
//    public func fetchAllCounters() throws -> [CounterEntity] {
//        let fetchRequest: NSFetchRequest<CounterEntity> = CounterEntity.fetchRequest()
//        do {
//            let entities = try managedObjectContext.fetch(fetchRequest)
//            return entities
//        } catch {
//            throw PersistenceManagerError.missingRecord
//        }
//    }
//    
//    public func updateCounterCount(id: String,
//                            newCount: Int32) throws {
//        let fetchRequest: NSFetchRequest<CounterEntity> = CounterEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//        guard let result = try? managedObjectContext.fetch(fetchRequest).first else {
//            throw PersistenceManagerError.missingRecord
//        }
//        result.setValue(newCount, forKey: "count")
//        
//        try save()
//    }
//    
//    public func updateCounterSyncState(id: String,
//                                syncState: Bool) throws {
//        let fetchRequest: NSFetchRequest<CounterEntity> = CounterEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//        guard let result = try? managedObjectContext.fetch(fetchRequest).first else {
//            throw PersistenceManagerError.missingRecord
//        }
//        result.setValue(syncState, forKey: "synched")
//        
//        try save()
//    }
//    
//    public func updateCounter(id: String,
//                              newId: String) throws {
//        let fetchRequest: NSFetchRequest<CounterEntity> = CounterEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//        guard let result = try? managedObjectContext.fetch(fetchRequest).first else {
//            throw PersistenceManagerError.missingRecord
//        }
//        result.setValue(newId, forKey: "id")
//        
//        try save()
//    }
//    
//    public func deleteCounter(id: String) throws {
//        let fetchRequest: NSFetchRequest<CounterEntity> = CounterEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//        
//        guard let result = try? managedObjectContext.fetch(fetchRequest).first else {
//            throw PersistenceManagerError.missingRecord
//        }
//        
//        managedObjectContext.delete(result)
//        
//        try save()
//    }
}
