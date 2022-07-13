//
//  PostsProvider.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Combine
import Domain

public final class PostsProvider: ObservableObject {
    private let postsService: PostsService
    private let persistenceManager: PersistenceManagerInterface
    
    @Published public var posts: [Post] = []
    @Published public var selectedPost: Post?
    
    // MARK: - Initializer
    public init(postsService: PostsService = PostsService(),
                persistenceManager: PersistenceManagerInterface = PersistenceManager.shared) {
        self.postsService = postsService
        self.persistenceManager = persistenceManager
    }
}

// MARK: - PostsProviderInterface
extension PostsProvider: PostsProviderInterface {    
    @MainActor public func getPosts() async throws {
        let entities = try persistenceManager.getPosts()
        
        guard entities.isEmpty else {
            posts = entities.map { $0.asDomain }
            return
        }
        
        let fetchedPosts = try await loadPostsFromRemoteAndSaveLocally()
        posts = fetchedPosts
    }
    
    public func loadPostsFromRemoteAndSaveLocally() async throws -> [Post] {
        do {
            let entities: [PostEntity] = try await postsService.request(endpoint: .list)
            
            var models: [Post] = []
            
            for entity in entities {
                do {
                    try persistenceManager.createPost(userId: Int32(entity.userId),
                                                      id: Int32(entity.id),
                                                      title: entity.title,
                                                      body: entity.body)
                    models.append(entity.asDomain)
                } catch {
                    continue
                }
            }
            
            try persistenceManager.save()
            return models
        } catch {
            throw PostsProviderError.serviceError
        }
    }
    
    @MainActor public func loadUserFromRemoteAndUpdateLocal() async throws {
        guard let post = selectedPost else {
            throw PostsProviderError.serviceError
        }
        let entity: UserEntity = try await postsService.request(endpoint: .user(post.userID))
        let coreDataEntity = persistenceManager.createUser(from: entity)
        
        try persistenceManager.updatePost(id: Int32(post.id), user: coreDataEntity)
        try persistenceManager.save()
        
        let model = try persistenceManager.getPost(id: Int32(post.id))
        selectedPost = model
    }
    
    
    @MainActor public func loadCommentsFromRemoteAndUpdateLocal() async throws {
        guard let post = selectedPost else {
            throw PostsProviderError.serviceError
        }
        let entities: [CommentEntity] = try await postsService.request(endpoint: .comments(post.id))
        
        var coreDataEntities: [CommentCDEntity] = []
        
        entities.forEach { entity in
            let model = persistenceManager.createComment(from: entity)
            coreDataEntities.append(model)
        }
        
        try persistenceManager.updatePost(id: Int32(post.id), comments: coreDataEntities)
        try persistenceManager.save()
        
        let model = try persistenceManager.getPost(id: Int32(post.id))
        selectedPost = model
    }
    
    public func setFavorite(_ newValue: Bool, of post: Post) throws {
        try persistenceManager.updateFavorite(newValue: newValue,
                                              postId: Int32(post.id))
        try persistenceManager.save()
    }
    
    public func deleteAll() throws {
        try persistenceManager.deleteAll()
        posts = []
    }
}
