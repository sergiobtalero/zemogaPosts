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

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /// Transforms an output value into a new publisher, and flattens the stream of events from these multiple upstream publishers to appear as if they were coming from a single stream of events
    ///
    /// Mapping to a new publisher will cancel the subscription to the previous one, keeping only a single
    /// subscription active along with its event emissions
    ///
    /// - parameter transform: A transform to apply to each emitted value, from which you can return a new Publisher
    ///
    /// - note: This operator is a combination of `map` and `switchToLatest`
    ///
    /// - returns: A publisher emitting the values of the latest inner publisher
    func flatMapLatest<P: Publisher>(_ transform: @escaping (Output) -> P) -> Publishers.SwitchToLatest<P, Publishers.Map<Self, P>> {
        map(transform).switchToLatest()
    }
}
#endif
