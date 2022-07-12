//
//  Endpoint.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
}
