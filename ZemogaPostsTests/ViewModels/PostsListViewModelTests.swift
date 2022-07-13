//
//  PostsListViewModelTests.swift
//  ZemogaPostsTests
//
//  Created by Sergio Bravo on 13/07/22.
//

@testable import ZemogaPosts
import Injector
import Combine
import Domain
import XCTest

class PostsListViewModelTests: XCTestCase {
    var deleteAllButtonTapPublisher: PassthroughSubject<Void, Never>!
    var refreshButtonTapPublisher: PassthroughSubject<Void, Never>!
    
    // MARK: - Setup
    override func setUpWithError() throws {
        deleteAllButtonTapPublisher = PassthroughSubject<Void, Never>()
        refreshButtonTapPublisher = PassthroughSubject<Void, Never>()
        
        DependencyContainer.removeAllDependencies()
        DependencyContainer.register(MockPostsProvider() as PostsProviderInterface)
    }

    override func tearDownWithError() throws {
        deleteAllButtonTapPublisher = nil
        refreshButtonTapPublisher = nil
    }

    // MARK: - Tests
    func test_setupSubscriptions() async {
        @Injected var postsProvider: PostsProviderInterface
        
        let viewModel = PostsListViewModel()
        let input = PostsListViewModel
            .Input(deleteAllButtonTapPublisher: deleteAllButtonTapPublisher.eraseToAnyPublisher(),
                   refreshButtonTapPublisher: refreshButtonTapPublisher.eraseToAnyPublisher())
        
        await viewModel.setupSubscriptions(input: input)
        XCTAssertEqual(postsProvider.posts.count, 100)
    }
    
    func test_deleteAction() async {
        @Injected var postsProvider: PostsProviderInterface
        
        let viewModel = PostsListViewModel()
        let input = PostsListViewModel
            .Input(deleteAllButtonTapPublisher: deleteAllButtonTapPublisher.eraseToAnyPublisher(),
                   refreshButtonTapPublisher: refreshButtonTapPublisher.eraseToAnyPublisher())
        
        await viewModel.setupSubscriptions(input: input)
        deleteAllButtonTapPublisher.send(())
        
        XCTAssertTrue(postsProvider.posts.isEmpty)
    }
    
    func test_RefreshAction() async {
        @Injected var postsProvider: PostsProviderInterface
        
        let viewModel = PostsListViewModel()
        let input = PostsListViewModel
            .Input(deleteAllButtonTapPublisher: deleteAllButtonTapPublisher.eraseToAnyPublisher(),
                   refreshButtonTapPublisher: refreshButtonTapPublisher.eraseToAnyPublisher())
        
        await viewModel.setupSubscriptions(input: input)
        refreshButtonTapPublisher.send(())
        
        XCTAssertEqual(postsProvider.posts.count, 100)
    }
}
