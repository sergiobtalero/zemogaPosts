//
//  PostEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

struct PostEntity: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension PostEntity: DomainConvertible {
    var asDomain: Post {
        Post(id: id,
             userID: userId,
             title: title,
             body: body,
             isFavorite: false,
             user: nil,
             comments: nil)
    }
}
