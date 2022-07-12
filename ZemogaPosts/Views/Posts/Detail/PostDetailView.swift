//
//  PostDetail.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import SwiftUI
import Combine
import Domain

struct PostDetailView: View {
    @StateObject var viewModel = PostDetailViewModel()
    
    private let favoriteTapPublisher = PassthroughSubject<Void, Never>()
    
    let post: Post
    
    // MARK: - Body
    var body: some View {
        Form {
            Section("Title") {
                Text(viewModel.post?.title ?? "No title")
            }
            
            Section("Description") {
                Text(viewModel.post?.body ?? "No description")
            }
            
            Section("User") {
                Text(viewModel.post?.user?.name ?? "No author name")
                Text(viewModel.post?.user?.email ?? "No author email")
                Text(viewModel.post?.user?.address?.street ?? "No author address")
                
                if let website = viewModel.post?.user?.website, !website.isEmpty {
                    Text(website)
                } else {
                    Text("No author website")
                }
                
            }
            
            if let comments = viewModel.post?.comments, !comments.isEmpty {
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
                if let post = viewModel.post {
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
            
            viewModel.setupSubscriptions(post: post,
                                         input: input)
        }
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: ModelsForPreviews.testPost)
    }
}
