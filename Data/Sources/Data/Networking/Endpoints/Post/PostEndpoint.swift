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
}

extension PostEndpoint: Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .list: return .get
        case .user: return .get
        }
    }
    
    var path: String {
        switch self {
        case .list: return "/posts"
        case let .user(id): return "/users/\(id)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .list: return nil
        case .user: return nil
        }
    }
}
