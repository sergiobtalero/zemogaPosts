//
//  MockPostsProvider.swift
//  ZemogaPostsTests
//
//  Created by Sergio Bravo on 13/07/22.
//

import Foundation
import Domain
import Data

enum TestError: Error {
    case testing
}

final class MockPostsProvider: PostsProviderInterface {
    var posts: [Post] = []
    var selectedPost: Post?
    
    func getPosts() async throws {
        let entities: [PostEntity] = try fetch(resourceName: "PostsList")
        let models = entities.map { $0.asDomain }
        posts = models
    }
    
    func loadPostsFromRemoteAndSaveLocally() async throws -> [Post] {
        let entities: [PostEntity] = try fetch(resourceName: "PostsList")
        let models = entities.map { $0.asDomain }
        posts = models
        return posts
    }
    
    func loadUserFromRemoteAndUpdateLocal() async throws {
        if selectedPost == nil {
            throw TestError.testing
        }

        let entity: UserEntity = try fetch(resourceName: "User")
        selectedPost?.user = entity.asDomain
    }
    
    func loadCommentsFromRemoteAndUpdateLocal() async throws {
        if selectedPost == nil {
            throw TestError.testing
        }

        let entities: [CommentEntity] = try fetch(resourceName: "Comments")
        selectedPost?.comments = entities.map { $0.asDomain }
    }
    
    func updateSelectedPost() throws {
        guard let selectedPost = selectedPost,
              let index = posts.firstIndex(where: { $0.id == selectedPost.id })else {
            throw TestError.testing
        }
        
        posts[index] = selectedPost
        self.selectedPost = nil
    }
    
    func deleteAll() throws {
        posts = []
    }
}

private extension MockPostsProvider {
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


