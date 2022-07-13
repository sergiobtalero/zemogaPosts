//
//  PostsProviderTests.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

@testable import Data
import CoreData
import XCTest

class PostsProviderTests: XCTestCase {
    var persistenceManager: PersistenceManager?
    
    // MARK: - Setup
    override func setUpWithError() throws {
        let modelName = "ZemogaPosts"
        
//        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.module]) else {
//            fatalError("Could not load managed object model")
//        }
//        guard let url = Bundle.module.url(forResource: modelName, withExtension: "momd"),
//              let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
//            fatalError("Could not load managed object model")
//        }
        
//        let description = NSPersistentStoreDescription()
//        description.url = URL(fileURLWithPath: "/dev/null")
//        
//        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
//        container.persistentStoreDescriptions = [description]
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        
//        persistenceManager = PersistenceManager(persistentContainer: container)
    }
    
    override func tearDownWithError() throws {
        persistenceManager = nil
    }
    
    // MARK: - Tests
    func test_getPostas_withNoSavedDataLocally() async throws {
        guard let data = postsListsData else {
            XCTFail("Could not load data foom json")
            return
        }
        
        let urlSession = MockURLSession(data: postsListsData, response: nil, error: nil)
        let service = PostsService(urlSession: urlSession)
        
        guard let persistenceManager = persistenceManager else {
            XCTFail("Could not load persistence manager")
            return
        }

        let provider = PostsProvider(postsService: service,
                                     persistenceManager: persistenceManager)
        try await provider.getPosts()
    }
}

// MARK: - Private helpers
private extension PostsProviderTests {
    var postsListsData: Data? {
        guard let url = Bundle.module.url(forResource: "PostsList", withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
}
