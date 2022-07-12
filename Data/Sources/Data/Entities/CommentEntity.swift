//
//  CommentEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

public struct CommentEntity: Codable {
    public let postId: Int
    public let id: Int
    public let name: String
    public let email: String
    public let body: String
}

// MARK: - DomainConvertible
extension CommentEntity: DomainConvertible {
    var asDomain: Comment {
        Comment(postId: postId,
                id: id,
                name: name,
                email: email,
                body: body)
    }
}
