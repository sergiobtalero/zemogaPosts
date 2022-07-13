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
    var posts: [Post] { get set }
    var selectedPost: Post? { get set }
    
    func getPosts() async throws
    
    @discardableResult func loadPostsFromRemoteAndSaveLocally() async throws -> [Post]
    func loadUserFromRemoteAndUpdateLocal() async throws
    func loadCommentsFromRemoteAndUpdateLocal() async throws
    func updateSelectedPost() throws
    
    func deleteAll() throws
}
