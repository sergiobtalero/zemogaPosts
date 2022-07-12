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

// MARK: - Subscriptions
extension PostDetailViewModel {
    func setupSubscriptions(post: Post) {
        subsribeToPostPublisher(post)
    }
}

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
