//
//  Comment.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

public struct Comment: Identifiable {
    public let postId: Int
    public let id: Int
    public let name: String
    public let email: String
    public let body: String
    
    // MARK: - Initializer
    public init(postId: Int,
                id: Int,
                name: String,
                email: String,
                body: String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}
