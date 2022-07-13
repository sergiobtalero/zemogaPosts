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
        guard let data = Self.data(resourceName: "PostsList") else {
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
        
        guard let data = Self.data(resourceName: "PostsList"),
              let entities: [PostEntity]? = Self.map(data: data) else {
            XCTFail("Could not load entities from json")
            return
        }
        
        guard let entities = entities else {
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
        guard let data = Self.data(resourceName: "PostsList") else {
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
        guard let data = Self.data(resourceName: "User"),
              let postsData = Self.data(resourceName: "PostsList"),
              let entities: [PostEntity] = Self.map(data: postsData),
              let post = entities.first else {
            XCTFail("Could not load test data")
            return
        }
        
        let user: UserEntity? = Self.map(data: data)
        XCTAssertNotNil(user?.asDomain)
        
        stub(condition: isPath("/posts")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/user/\(post.userId)")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }
        
        let service = PostsService()
        
        guard let persistenceManager = persistenceManager else {
            XCTFail("Could not load persistence manager")
            return
        }
        
        try persistenceManager.createPost(userId: Int32(post.userId),
                                      id: Int32(post.id),
                                      title: post.title, body: post.body)

        let provider = PostsProvider(postsService: service,
                                     persistenceManager: persistenceManager)
        provider.selectedPost = post.asDomain
        try await provider.getPosts()
        try await provider.loadUserFromRemoteAndUpdateLocal()
        
        XCTAssertNotNil(provider.selectedPost?.user)
    }
    
    func test_loadCommentsFromRemoteAndUpdateLocal() async throws {
        guard let data = Self.data(resourceName: "Comments"),
              let postsData = Self.data(resourceName: "PostsList"),
              let entities: [PostEntity] = Self.map(data: postsData),
              let post = entities.first else {
            XCTFail("Could not load test data")
            return
        }
        
        let comments: [CommentEntity]? = Self.map(data: data)
        XCTAssertNotNil(comments?.first?.asDomain)
        
        stub(condition: isPath("/posts")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(data: postsData, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/posts/\(post.id)/comments")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }
        
        let service = PostsService()
        
        guard let persistenceManager = persistenceManager else {
            XCTFail("Could not load persistence manager")
            return
        }
        
        try persistenceManager.createPost(userId: Int32(post.userId),
                                      id: Int32(post.id),
                                      title: post.title, body: post.body)

        let provider = PostsProvider(postsService: service,
                                     persistenceManager: persistenceManager)
        provider.selectedPost = post.asDomain
        try await provider.getPosts()
        try await provider.loadCommentsFromRemoteAndUpdateLocal()
        
        guard let comments = provider.selectedPost?.comments else {
            XCTFail("Could not find comments")
            return
        }
        
        XCTAssertEqual(comments.count, 5)
    }
    
    func test_updateSelectedPost() async throws {
        guard let data = Self.data(resourceName: "Comments"),
              let postsData = Self.data(resourceName: "PostsList"),
              let entities: [PostEntity] = Self.map(data: postsData),
              let post = entities.first else {
            XCTFail("Could not load test data")
            return
        }
        
        let comments: [CommentEntity]? = Self.map(data: data)
        XCTAssertNotNil(comments?.first?.asDomain)
        
        stub(condition: isPath("/posts")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(data: postsData, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/posts/\(post.id)/comments")) { _ in
            return OHHTTPStubs.HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }
        
        let service = PostsService()
        
        guard let persistenceManager = persistenceManager else {
            XCTFail("Could not load persistence manager")
            return
        }
        
        try persistenceManager.createPost(userId: Int32(post.userId),
                                      id: Int32(post.id),
                                      title: post.title, body: post.body)

        let provider = PostsProvider(postsService: service,
                                     persistenceManager: persistenceManager)
        provider.selectedPost = post.asDomain
        try await provider.getPosts()
        try await provider.loadCommentsFromRemoteAndUpdateLocal()
        try await provider.updateSelectedPost()
        
        XCTAssertNil(provider.selectedPost)
    }
}

// MARK: - Private helpers
private extension PostsProviderTests {
    static func data(resourceName: String) -> Data? {
        guard let url = Bundle.module.url(forResource: resourceName, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
    static func map<T: Codable>(data: Data) -> T? {
        let decodedData = try? JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
