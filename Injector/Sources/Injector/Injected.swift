//
//  Injected.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

@propertyWrapper
public struct Injected<T> {
    public var wrappedValue: T

    public init() {
        self.wrappedValue = DependencyContainer.resolve()
    }
}
