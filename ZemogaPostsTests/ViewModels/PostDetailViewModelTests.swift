//
//  PostDetailViewModelTests.swift
//  ZemogaPostsTests
//
//  Created by Sergio Bravo on 13/07/22.
//

@testable import ZemogaPosts
import Injector
import Combine
import Domain
import XCTest
import Data

class PostDetailViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        DependencyContainer.removeAllDependencies()
        DependencyContainer.register(MockPostsProvider() as PostsProviderInterface)
    }

    // MARK: - Tests
    func test_setupSubscriptions() async throws {
        @Injected var postsProvider: PostsProviderInterface
        
        let entities: [PostEntity] = try fetch(resourceName: "PostsList")
        guard let post = entities.first?.asDomain else {
            XCTFail("Could not load post from json")
            return
        }
        
        let viewModel = PostDetailViewModel()
        await viewModel.setupSubscriptions(post: post)
        XCTAssertNotNil(postsProvider.selectedPost)
    }
    
    func test_toggleFavorite_saveLocally() async throws {
        @Injected var postsProvider: PostsProviderInterface
        try await postsProvider.getPosts()
        
        let entities: [PostEntity] = try fetch(resourceName: "PostsList")
        guard let post = entities.first?.asDomain else {
            XCTFail("Could not load post from json")
            return
        }
        
        let viewModel = PostDetailViewModel()
        await viewModel.setupSubscriptions(post: post)
        viewModel.toggleFavorite()
        try viewModel.saveChanges()
        
        XCTAssertNil(postsProvider.selectedPost)
        
        guard let matchPost = postsProvider.posts.first(where: { $0.id == post.id }) else {
            XCTFail("Could not locate matching post")
            return
        }
        
        XCTAssertNotEqual(matchPost.isFavorite, post.isFavorite)
    }
}

private extension PostDetailViewModelTests {
    private func fetch<T: Codable>(resourceName: String) throws -> T {
        guard let url = Bundle(for: type(of: self)).url(forResource: resourceName, withExtension: "json") else {
            throw TestError.testing
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw TestError.testing
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
