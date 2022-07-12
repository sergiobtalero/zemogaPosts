//
//  ContentView.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import SwiftUI
import Domain

struct PostsListView: View {
    @StateObject var viewModel = PostsListViewModel()
    
    @State private var scope = 0
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Picker("Scope", selection: $scope) {
                    Text("All").tag(0)
                    Text("Favorites").tag(1)
                }
                .pickerStyle(.segmented)
                
                List(viewModel.posts) { post in
                    NavigationLink {
                        PostDetailView(post: post)
                    } label: {
                        Text("\(post.title)")
                    }

                }
                .listStyle(.plain)
            }
            .navigationTitle("Posts")
            .task {
                viewModel.setupSubscriptions()
            }
            .onChange(of: scope) { newValue in
                viewModel.toggleScope()
            }
        }
        
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
