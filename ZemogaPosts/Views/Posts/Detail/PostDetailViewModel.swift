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
}

// MARK: - Public methods
extension PostDetailViewModel {
    func setupSubscriptions(post: Post) async {
        postsProvider.selectedPost = post
        
        if postsProvider.selectedPost?.user == nil {
            try? await postsProvider.loadUserFromRemoteAndUpdateLocal()
        }
        
        if postsProvider.selectedPost?.comments?.isEmpty ?? true {
            try? await postsProvider.loadCommentsFromRemoteAndUpdateLocal()
        }
    }
    
    func saveChanges() throws {
        try postsProvider.updateSelectedPost()
    }
    
    func toggleFavorite() {
        postsProvider.selectedPost?.isFavorite.toggle()
    }
}
