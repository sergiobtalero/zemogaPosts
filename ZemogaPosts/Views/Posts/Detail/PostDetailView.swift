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
        Text("Hello, World! \(viewModel.post?.user?.name ?? "NOTHING")")
            .task {
                viewModel.setupSubscriptions(post: post)
            }
    }
}

//struct PostDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetail()
//    }
//}
