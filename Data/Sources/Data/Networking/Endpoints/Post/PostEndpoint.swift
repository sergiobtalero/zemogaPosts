//
//  PostEndpoint.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

enum PostEndpoint {
    case list
    case user(Int)
    case comments(Int)
}

extension PostEndpoint: Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .list: return .get
        case .user: return .get
        case .comments: return .get
        }
    }
    
    var path: String {
        switch self {
        case .list: return "/posts"
        case let .user(id): return "/users/\(id)"
        case let .comments(postId): return "/posts/\(postId)/comments"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .list: return nil
        case .user: return nil
        case .comments: return nil
        }
    }
}
