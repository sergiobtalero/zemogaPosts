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
    
    // MARK: - Initializer
    public init(postsService: PostsService = PostsService(),
                persistenceManager: PersistenceManagerInterface = PersistenceManager.shared) {
        self.postsService = postsService
        self.persistenceManager = persistenceManager
    }
}

// MARK: - PostsProviderInterface
extension PostsProvider: PostsProviderInterface {
    public func getPostsPublisher() -> AnyPublisher<[Post], Never> {
        CDPublisher(request: PostCDEntity.fetchRequest(),
                    context: PersistenceManager.shared.managedObjectContext)
        .map { entities in
            entities.map {
                let commentsEntities = $0.comments?.allObjects as? [CommentCDEntity]
                let comments = commentsEntities?.compactMap { $0.asDomain }
                
                return Post(id: Int($0.id),
                     userID: Int($0.userId),
                     title: $0.title ?? "",
                     body: $0.body ?? "",
                     isFavorite: $0.isFavorite,
                     user: $0.user?.asDomain,
                     comments: comments)
            }
        }
        .replaceError(with: [])
        .eraseToAnyPublisher()
    }
    
    public func getPostPublisher(id: Int) -> AnyPublisher<Post, Error> {
        CDPublisher(request: PostCDEntity.fetchRequest(),
                    context: PersistenceManager.shared.managedObjectContext)
        .compactMap { elements in
            guard let firstMatch = elements.first(where: { $0.id == id }) else {
                return nil
            }
            
            let commentsEntities = firstMatch.comments?.allObjects as? [CommentCDEntity]
            let comments = commentsEntities?.compactMap { $0.asDomain }
            
            return Post(id: Int(firstMatch.id),
                        userID: Int(firstMatch.userId),
                        title: firstMatch.title ?? "",
                        body: firstMatch.body ?? "",
                        isFavorite: firstMatch.isFavorite,
                        user: firstMatch.user?.asDomain,
                        comments: comments)
        }
        .eraseToAnyPublisher()
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
    
    @discardableResult
    public func loadUserFromRemoteAndSaveLocally(of post: Post) async throws -> User {
        let entity: UserEntity = try await postsService.request(endpoint: .user(post.userID))
        let coreDataEntity = persistenceManager.createUser(from: entity)
        try persistenceManager.updatePost(id: Int32(post.id), user: coreDataEntity)
        try persistenceManager.save()
        return entity.asDomain
    }
    
    @discardableResult
    public func loadCommentsFromRemoteAndSaveLocally(of post: Post) async throws -> [Comment] {
        let entities: [CommentEntity] = try await postsService.request(endpoint: .comments(post.id))
        var comments: [CommentCDEntity] = []
        
        for entity in entities {
            let model = persistenceManager.createComment(from: entity)
            comments.append(model)
        }
        
        try persistenceManager.updatePost(id: Int32(post.id), comments: comments)
        try persistenceManager.save()
        
        return comments.map { $0.asDomain }
    }
    
    public func setFavorite(_ newValue: Bool, of post: Post) throws {
        try persistenceManager.updateFavorite(newValue: newValue,
                                              postId: Int32(post.id))
        try persistenceManager.save()
    }
}
