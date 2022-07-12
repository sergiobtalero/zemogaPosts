//
//  PostsListViewModel.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Injector
import Combine
import Domain

final class PostsListViewModel: ObservableObject {
    @Injected private var postsProvider: PostsProviderInterface
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var posts: [Post] = []
}

// MARK: - Public methods
extension PostsListViewModel {
    func setupSubscriptions() {
        subscribeToPostsPublisher()
    }
}

// MARK: - Private methods
private extension PostsListViewModel {
    private func subscribeToPostsPublisher() {
        postsProvider.getPostsPublisher()
            .dropFirst()
            .sink { [weak self] posts in
                if posts.isEmpty {
                    self?.loadPostsFromServer()
                }
                
                self?.posts = posts
            }
            .store(in: &subscriptions)
    }
    
    private func loadPostsFromServer() {
        Task {
            let posts = try await postsProvider.loadPostsFromRemoteAndSaveLocally()
            print(posts.count)
        }
    }
}
