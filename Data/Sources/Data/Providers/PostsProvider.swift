//
//  PostsProvider.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

public enum PostsProviderError: Error {
    case serviceError
}

public protocol PostsProviderInterface {
//    func loadPosts() async throws -> [PostEntity]
}

public final class PostsProvider {
    private let postsService: PostsService
    
    // MARK: - Initializer
    public init(postsService: PostsService = PostsService()) {
        self.postsService = postsService
    }
}

// MARK: - PostsProviderInterface
extension PostsProvider: PostsProviderInterface {
//    public func loadPosts() async throws -> [PostEntity] {
//        do {
//            let posts: [PostEntity]? = try await postsService.request(endpoint: .list)
//            return posts ?? []
//        } catch {
//            throw PostsProviderError.serviceError
//        }
//    }
}
