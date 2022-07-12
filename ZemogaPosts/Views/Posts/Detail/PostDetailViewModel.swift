//
//  PostDetailViewModel.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Injector
import Combine
import Domain

final class PostDetailViewModel: ObservableObject {
    @Injected private var postsProvider: PostsProviderInterface
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var post: Post?
    
    deinit {
        subscriptions.removeAll()
    }
}

// MARK: - Public methods
extension PostDetailViewModel {
    func setupSubscriptions(post: Post,
                            input: Input) {
        subsribeToPostPublisher(post)
        subscribeToFavoritePublisher(input.favoriteTapPublisher)
    }
    
    func saveChanges() {
        if let post = post {
            try? postsProvider.setFavorite(post.isFavorite, of: post)
        }
    }
}

// MARK: - Private methods
private extension PostDetailViewModel {
    private func subsribeToPostPublisher(_ post: Post) {
        postsProvider.getPostPublisher(id: post.id)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] post in
                    if post.user == nil {
                        self?.loadUser(post)
                    }
                    
                    if post.comments?.isEmpty ?? true {
                        self?.loadComments(post)
                    }
                    
                    self?.post = post
                })
            .store(in: &subscriptions)
    }
    
    private func subscribeToFavoritePublisher(_ publisher: AnyPublisher<Void, Never>) {
        publisher
            .sink { [weak self] _ in
                self?.post?.isFavorite.toggle()
            }
            .store(in: &subscriptions)
    }
    
    private func loadUser(_ post: Post) {
        Task {
            try await postsProvider.loadUserFromRemoteAndSaveLocally(of: post)
        }
    }
    
    
    private func loadComments(_ post: Post) {
        Task {
            try await postsProvider.loadCommentsFromRemoteAndSaveLocally(of: post)
        }
    }
}

// MARK: - Output Builder
extension PostDetailViewModel {
    struct Input {
        let favoriteTapPublisher: AnyPublisher<Void, Never>
    }
}
