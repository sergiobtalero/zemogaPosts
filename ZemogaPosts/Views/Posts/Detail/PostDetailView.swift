//
//  PostDetail.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import SwiftUI
import Domain

struct PostDetailView: View {
    @StateObject var viewModel = PostDetailViewModel()
    
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
            }
        }
        .navigationTitle("Post")
        .task {
            viewModel.setupSubscriptions(post: post)
        }
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: ModelsForPreviews.testPost)
    }
}
