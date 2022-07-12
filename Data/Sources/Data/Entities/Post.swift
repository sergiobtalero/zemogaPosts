//
//  PostEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

struct PostEntity: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    let isFavorite: Bool = false
}
