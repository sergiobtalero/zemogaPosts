//
//  User.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

public struct User: Identifiable {
    public let id: Int
    public let name: String
    public let username: String
    public let email: String
    public let address: Address?
    public let phone: String
    public let website: String
    public let company: Company?
    
    // MARK: - Initializer
    public init(id: Int,
                name: String,
                username: String,
                email: String,
                address: Address?,
                phone: String,
                website: String,
                company: Company?) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
}
