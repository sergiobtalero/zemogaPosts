//
//  PersistenceManager.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import CoreData
import Domain

public class PersistenceManager {
    public static let shared = PersistenceManager()
    
    var persistentContainer: NSPersistentContainer
    
    // MARK: - Initializer
    init(persistentContainer: NSPersistentContainer = NSPersistentContainer.main) {
        self.persistentContainer = persistentContainer
    }
}

// MARK: - PersistenceManagerInterface
extension PersistenceManager: PersistenceManagerInterface {
    public func save() throws {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            rollback()
            throw PersistenceManagerError.operationFailed
        }
    }
    
    public func rollback() {
        persistentContainer.viewContext.rollback()
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

// MARK: - Create methods
extension PersistenceManager {
    public func createPost(userId: Int32,
                           id: Int32,
                           title: String,
                           body: String) throws {
        let newPost = PostCDEntity(context: persistentContainer.viewContext)
        newPost.userId = userId
        newPost.id = id
        newPost.title = title
        newPost.body = body
        newPost.isFavorite = false
    }
    
    @discardableResult
    public func createUser(from entity: UserEntity) -> UserCDEntity {
        let newUser = UserCDEntity(context: persistentContainer.viewContext)
        newUser.id = Int32(entity.id)
        newUser.name = entity.name
        newUser.username = entity.username
        newUser.email = entity.email
        newUser.address = createAddress(from: entity.address)
        newUser.company = createCompany(from: entity.company)
        
        return newUser
    }
    
    @discardableResult
    public func createAddress(from entity: AddressEntity) -> AddressCDEntity {
        let newAddress = AddressCDEntity(context: persistentContainer.viewContext)
        newAddress.street = entity.street
        newAddress.suite = entity.suite
        newAddress.city = entity.city
        newAddress.zipcode = entity.zipcode
        
        if let lat = Double(entity.geo.lat),
            let lng = Double(entity.geo.lng) {
            newAddress.lat = lat
            newAddress.lng = lng
        }
        
        return newAddress
    }
    
    @discardableResult
    public func createCompany(from entity: CompanyEntity) -> CompanyCDEntity {
        let newCompany = CompanyCDEntity(context: persistentContainer.viewContext)
        newCompany.bs = entity.bs
        newCompany.catchPhrase = entity.catchPhrase
        newCompany.name = entity.name
        
        return newCompany
    }
    
    @discardableResult
    public func createComment(from entity: CommentEntity) -> CommentCDEntity {
        let newComment = CommentCDEntity(context: persistentContainer.viewContext)
        newComment.postId = Int32(entity.postId)
        newComment.id = Int32(entity.id)
        newComment.name = entity.name
        newComment.email = entity.email
        newComment.body = entity.body
        
        return newComment
    }
}

// MARK: - Fetch methods
extension PersistenceManager {
    public func getPosts() throws -> [PostCDEntity] {
        let fetchRequest: NSFetchRequest<PostCDEntity> = PostCDEntity.fetchRequest()
        
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            throw PersistenceManagerError.missingRecord
        }
        
        return result
    }
    
    public func getPost(id: Int32) throws -> Post {
        let fetchRequest: NSFetchRequest<PostCDEntity> = PostCDEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw PersistenceManagerError.missingRecord
        }
        
        return result.asDomain
    }
    
    public func getUser(id: Int) throws -> UserCDEntity {
        let fetchRequest: NSFetchRequest<UserCDEntity> = UserCDEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw PersistenceManagerError.missingRecord
        }
        
        return result
    }
}

// MARK: - Update methods
extension PersistenceManager {
    public func updatePost(id: Int32,
                           user: UserCDEntity) throws {
        let fetchRequest: NSFetchRequest<PostCDEntity> = PostCDEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw PersistenceManagerError.missingRecord
        }
        result.setValue(user, forKey: "user")
    }
    
    public func updatePost(id: Int32,
                           comments: [CommentCDEntity]) throws {
        let fetchRequest: NSFetchRequest<PostCDEntity> = PostCDEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw PersistenceManagerError.missingRecord
        }
        let commentsSet = NSSet(array: comments)
        result.setValue(commentsSet, forKey: "comments")
    }
    
    public func updateFavorite(newValue: Bool,
                               postId: Int32) throws {
        let fetchRequest: NSFetchRequest<PostCDEntity> = PostCDEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", postId)
        
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            throw PersistenceManagerError.missingRecord
        }
        
        result.setValue(newValue, forKey: "isFavorite")
    }
}

// MARK: - Delete methods
extension PersistenceManager {
    public func deleteAll() throws {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostCDEntity")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
    }
}
