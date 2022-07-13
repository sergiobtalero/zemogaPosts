//
//  ZemogaPostsApp.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import SwiftUI
import Injector

@main
struct ZemogaPostsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            PostsListView()
                .environmentObject(Injector.DependencyContainer.getPostsProvider())
        }
    }
}
