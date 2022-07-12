//
//  ModelsForPreviews.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

struct ModelsForPreviews {
    static var testPost: Post {
        Post(id: 1,
             userID: 1,
             title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
             body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
             isFavorite: true,
             user: nil,
             comments: nil)
    }
}
