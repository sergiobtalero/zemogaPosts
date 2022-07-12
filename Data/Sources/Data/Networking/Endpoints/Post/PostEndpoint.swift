//
//  PostEndpoint.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

enum PostEndpoint {
    case list
}

extension PostEndpoint: Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .list: return .get
        }
    }
    
    var path: String {
        switch self {
        case .list: return "/posts"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .list: return nil
        }
    }
}
