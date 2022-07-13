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
}

// MARK: - Public methods
extension PostsListViewModel {
    func setupSubscriptions(input: Input) async {
        try? await subscribeToPostsPublisher()
        subscribeToDeleteAllTapPublisher(input.deleteAllButtonTapPublisher)
        subscribeToRefreshPublisher(input.refreshButtonTapPublisher)
    }
}

// MARK: - Private methods
private extension PostsListViewModel {
    private func subscribeToPostsPublisher() async throws {
        try? await postsProvider.getPosts()
    }
    
    private func subscribeToDeleteAllTapPublisher(_ publisher: AnyPublisher<Void, Never>) {
        publisher
            .sink { [weak self] _ in
                do {
                    try self?.postsProvider.deleteAll()
                } catch {
                    print("Error")
                }
            }
            .store(in: &subscriptions)
    }
    
    private func subscribeToRefreshPublisher(_ publisher: AnyPublisher<Void, Never>) {
        publisher.sink { _ in
            print("Refresh tappped")
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

// MARK: - Output builder
extension PostsListViewModel {
    struct Input {
        let deleteAllButtonTapPublisher: AnyPublisher<Void, Never>
        let refreshButtonTapPublisher: AnyPublisher<Void, Never>
    }
}
