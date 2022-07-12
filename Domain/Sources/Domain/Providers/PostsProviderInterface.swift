//
//  PostsProviderInterface.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Combine

public enum PostsProviderError: Error {
    case serviceError
}

public protocol PostsProviderInterface {
    func getPostsPublisher() -> AnyPublisher<[Post], Never>
    func getPostPublisher(id: Int) -> AnyPublisher<Post, Error>
    
    func loadPostsFromRemoteAndSaveLocally() async throws -> [Post]
    func loadUserFromRemoteAndSaveLocally(of post: Post) async throws -> User
    func loadCommentsFromRemoteAndSaveLocally(of post: Post) async throws -> [Comment]
}
