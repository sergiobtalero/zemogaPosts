//
//  PostsProviderTests.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

@testable import Data
import OHHTTPStubsSwift
import OHHTTPStubs
import CoreData
import XCTest
import Domain

enum TestError: Error {
    case testing
}

class PostsProviderTests: XCTestCase {
    var persistenceManager: PersistenceManager?
    
    // MARK: - Setup
    override func setUpWithError() throws {
        let modelName = "ZemogaPosts"
        
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [BundleReference.bundle]) else {
            fatalError("Could not load managed object model")
        }
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")

        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        persistenceManager = PersistenceManager(persistentContainer: container)
    }
    
    override func tearDownWithError() throws {
        persistenceManager = nil
    }
    
    // MARK: - Tests
    func test_getPosts_withNoSavedDataLocally() async throws {
        guard let data = postsListsData else {
            XCTFail("Could not load data foom json")
            return
        }
        
        stub(condition: isPath("/posts")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }
        
        let service = PostsService()
        
        guard let persistenceManager = persistenceManager else {
            XCTFail("Could not load persistence manager")
            return
        }

        let provider = PostsProvider(postsService: service,
                                     persistenceManager: persistenceManager)
        try await provider.getPosts()
        XCTAssertEqual(provider.posts.count, 100)
    }
    
    func test_getPosts_withSavedDataLocally() async throws {
        guard let persistenceManager = persistenceManager else {
            XCTFail("Could not load persistence manager")
            return
        }
        
        guard let entities = postsListsEntities else {
            XCTFail("Could not load entities from json")
            return
        }
        
        try entities.forEach { entity in
            try persistenceManager.createPost(userId: Int32(entity.userId),
                                              id: Int32(entity.id),
                                              title: entity.title,
                                              body: entity.body)
        }

        let service = PostsService()
        let provider = PostsProvider(postsService: service,
                                     persistenceManager: persistenceManager)
        try await provider.getPosts()
        XCTAssertEqual(provider.posts.count, 100)
    }
    
    func test_loadPostsFromRemoteAndSaveLocally_withServiceError() async throws {
        guard let data = postsListsData else {
            XCTFail("Could not load data foom json")
            return
        }
        
        stub(condition: isPath("/posts")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(error: TestError.testing)
        }
        
        let service = PostsService()
        
        guard let persistenceManager = persistenceManager else {
            XCTFail("Could not load persistence manager")
            return
        }

        let provider = PostsProvider(postsService: service,
                                     persistenceManager: persistenceManager)
        do {
            try await provider.loadPostsFromRemoteAndSaveLocally()
            XCTFail("Unexpected respons")
        } catch {
            XCTAssertEqual(error as? PostsProviderError, .serviceError)
        }
    }
    
    func test_loadUserFromRemoteAndUpdateLocal() async throws {
        guard let data = Self.data(resourceName: "User") else {
            XCTFail("Could not load data from json file")
            return
        }
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
    
    var postsListsEntities: [PostEntity]? {
        guard let data = postsListsData else {
            return nil
        }
        
        let entities = try? JSONDecoder().decode([PostEntity].self, from: data)
        return entities
    }
    
    static func data(resourceName: String) -> Data? {
        guard let url = Bundle.module.url(forResource: resourceName, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
