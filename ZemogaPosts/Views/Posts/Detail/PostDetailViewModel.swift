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
}

// MARK: - Public methods
extension PostDetailViewModel {
    func setupSubscriptions(post: Post,
                            input: Input) async {
        subscribeToFavoritePublisher(input.favoriteTapPublisher)
        
        postsProvider.selectedPost = post
        
        if postsProvider.selectedPost?.user == nil {
            try? await postsProvider.loadUserFromRemoteAndUpdateLocal()
        }
        
        if postsProvider.selectedPost?.comments?.isEmpty ?? true {
            try? await postsProvider.loadCommentsFromRemoteAndUpdateLocal()
        }
    }
    
    func saveChanges() {
        if let post = postsProvider.selectedPost {
            try? postsProvider.setFavorite(post.isFavorite, of: post)
        }
    }
}

// MARK: - Private methods
private extension PostDetailViewModel {
    private func subscribeToFavoritePublisher(_ publisher: AnyPublisher<Void, Never>) {
        publisher
            .sink { [weak self] _ in
                print("HELLO")
                self?.postsProvider.selectedPost?.isFavorite.toggle()
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Output Builder
extension PostDetailViewModel {
    struct Input {
        let favoriteTapPublisher: AnyPublisher<Void, Never>
    }
}
