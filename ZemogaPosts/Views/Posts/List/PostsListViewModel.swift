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
    
    private var currentScope = CurrentValueSubject<PostsScope, Never>(.all)
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var posts: [Post] = []
}

extension PostsListViewModel {
    enum PostsScope: Int {
        case all
        case favorite
    }
}

// MARK: - Public methods
extension PostsListViewModel {
    func setupSubscriptions() {
        subscribeToPostsPublisher()
    }
    
    func toggleScope() {
        currentScope.value = currentScope.value == .all ? .favorite : .all
    }
}

// MARK: - Private methods
private extension PostsListViewModel {
    private func subscribeToPostsPublisher() {
        postsProvider.getPostsPublisher()
            .dropFirst()
            .combineLatest(currentScope)
            .sink { [weak self] posts, scope in
                if posts.isEmpty {
                    self?.loadPostsFromServer()
                }
                
                if scope == .all {
                    self?.posts = posts
                } else {
                    self?.posts = posts.filter { $0.isFavorite }
                }
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
