//
//  Post.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

public struct Post: Identifiable {
    public let id: Int
    public let userID: Int
    public let title: String
    public let body: String
    public var isFavorite: Bool
    public let user: User?
    public let comments: [Comment]?
    
    // MARK: - Initializer
    public init(id: Int,
                userID: Int,
                title: String,
                body: String,
                isFavorite: Bool,
                user: User?,
                comments: [Comment]?) {
        self.id = id
        self.userID = userID
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
        self.user = user
        self.comments = comments
    }
}
