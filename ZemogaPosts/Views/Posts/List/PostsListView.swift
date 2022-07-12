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
                .padding([.bottom, .horizontal])
                
                if !viewModel.posts.isEmpty {
                    List(viewModel.posts) { post in
                        NavigationLink {
                            PostDetailView(post: post)
                        } label: {
                            Text("\(post.title)")
                        }

                    }
                    .listStyle(.plain)
                    .padding(.bottom, -8)
                } else {
                    Text("Nothing to show")
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
//                        .background(Color.white)
                        .padding(.bottom, -8)
                }
                
                
                Button(action: {
                    print("Delete all tapped")
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
                    print("Refresh tapped")
                } label: {
                    Image(systemName: "arrow.clockwise")
                }

            })
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
