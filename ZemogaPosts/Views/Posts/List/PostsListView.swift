//
//  ContentView.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import SwiftUI
import Combine
import Domain
import Data

struct PostsListView: View {
    @StateObject var viewModel = PostsListViewModel()
    @EnvironmentObject var postsProvider: PostsProvider
    
    @State private var scope = 0
    
    private let deleteAllButtonTapPublisher = PassthroughSubject<Void, Never>()
    private let refreshButtonTapPublisher = PassthroughSubject<Void, Never>()
    
    private var renderedPosts: [Post] {
        if scope == 0 {
            return postsProvider.posts
        } else {
            return postsProvider.posts.filter { $0.isFavorite }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Picker("Scope", selection: $scope) {
                    Text("All").tag(0)
                    Text("Favorites").tag(1)
                }
                .pickerStyle(.segmented)
                .padding([.bottom, .horizontal])
                
                if !postsProvider.posts.isEmpty {
                    List(renderedPosts) { post in
                        NavigationLink {
                            PostDetailView(post: post)
                        } label: {
                            HStack {
                                if post.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color.yellow)
                                }
                                Text("\(post.title)")
                            }
                        }

                    }
                    .listStyle(.plain)
                    .padding(.bottom, -8)
                } else {
                    Text("Nothing to show")
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
                        .padding(.bottom, -8)
                }
                
                
                Button(action: {
                    deleteAllButtonTapPublisher.send(())
                }, label: {
                    Text("Delete all")
                        .foregroundColor(Color.white)
                })
                .padding(.top)
                .frame(maxWidth: .infinity)
                .background(Color.red)
            }
            .navigationTitle("Posts")
            .toolbar(content: {
                Button {
                    refreshButtonTapPublisher.send(())
                } label: {
                    Image(systemName: "arrow.clockwise")
                }

            })
            .onAppear {
                let input = PostsListViewModel.Input(deleteAllButtonTapPublisher: deleteAllButtonTapPublisher.eraseToAnyPublisher(),
                                                     refreshButtonTapPublisher: refreshButtonTapPublisher.eraseToAnyPublisher())
                Task {
                    await viewModel.setupSubscriptions(input: input)
                }
            }
        }
        
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
