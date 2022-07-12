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
                Post(id: Int($0.id),
                     userID: Int($0.userId),
                     title: $0.title ?? "",
                     body: $0.body ?? "",
                     isFavorite: $0.isFavorite,
                     user: nil)
            }
        }
        .replaceError(with: [])
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
}
