//
//  PostDetail.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import SwiftUI
import Combine
import Domain
import Data

struct PostDetailView: View {
    @StateObject var viewModel = PostDetailViewModel()
    @EnvironmentObject var postsProvider: PostsProvider
    
    private let favoriteTapPublisher = PassthroughSubject<Void, Never>()
    
    let post: Post
    
    // MARK: - Initializer
    init(post: Post) {
        self.post = post
    }
    
    // MARK: - Body
    var body: some View {
        Form {
            Section("Title") {
                Text(postsProvider.selectedPost?.title ?? "No title")
            }
            
            Section("Description") {
                Text(postsProvider.selectedPost?.body ?? "No description")
            }
            
            Section("User") {
                Text(postsProvider.selectedPost?.user?.name ?? "No author name")
                Text(postsProvider.selectedPost?.user?.email ?? "No author email")
                Text(postsProvider.selectedPost?.user?.address?.street ?? "No author address")
                
                if let website = postsProvider.selectedPost?.user?.website, !website.isEmpty {
                    Text(website)
                } else {
                    Text("No author website")
                }
                
            }
            
            if let comments = postsProvider.selectedPost?.comments, !comments.isEmpty {
                Section("Comments") {
                    ForEach(comments) { comment in
                        Text(comment.body)
                    }
                }
                .animation(.easeIn, value: comments)
            }
        }
        .navigationTitle("Post")
        .toolbar(content: {
            Button {
                favoriteTapPublisher.send(())
            } label: {
                if let post = postsProvider.selectedPost {
                    Image(systemName: post.isFavorite ? "star.fill" : "star")
                        .foregroundColor(Color.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(Color.yellow)
                }
            }

        })
        .onDisappear {
            viewModel.saveChanges()
        }
        .task {
            let input = PostDetailViewModel.Input(favoriteTapPublisher: favoriteTapPublisher.eraseToAnyPublisher())
            await viewModel.setupSubscriptions(post: post,
                                               input: input)
        }
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: ModelsForPreviews.testPost)
    }
}
