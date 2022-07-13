//
//  DependencyContainer.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain
import Data

public final class DependencyContainer {
    private var dependencies = [String: AnyObject]()
    private static var shared = DependencyContainer()

    // MARK: - Methods
    public static func register<T>(_ dependency: T) {
        shared.register(dependency)
    }

    public static func resolve<T>() -> T {
        shared.resolve()
    }

    private func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency as AnyObject
    }

    private func resolve<T>() -> T {
        let key = String(describing: T.self)
        let dependency = dependencies[key] as? T

        precondition(dependency != nil, "No dependency found for \(key)! must register a dependency before resolve.")

        return dependency!
    }
}

// MARK: - Register Dependency
extension DependencyContainer {
    @discardableResult
    public static func getPostsProvider() -> PostsProvider {
        if let dependency = shared.dependencies.first(where: { $0.key == "PostsProviderInterface" }) as? PostsProvider {
            return dependency
        }
        
        let provider = PostsProvider()
        shared.register(provider as PostsProviderInterface)
        return provider
    }
    
    public static func removeAllDependencies() {
        shared.dependencies.removeAll()
    }
}
