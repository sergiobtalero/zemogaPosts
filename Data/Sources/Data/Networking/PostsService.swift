//
//  PostsService.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case badParsing
}

public final class PostsService {
    private static let baseURL = "https://jsonplaceholder.typicode.com"
    private let urlSession: URLSession
    
    // MARK: - Initializer
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Methods
    func request<T: Decodable>(endpoint: PostEndpoint) async throws -> T {
        let urlString = Self.baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = endpoint.parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let parsedObjects = try jsonDecoder.decode(T.self, from: data)
            return parsedObjects
        } catch {
            throw NetworkError.badParsing
        }
    }
}
