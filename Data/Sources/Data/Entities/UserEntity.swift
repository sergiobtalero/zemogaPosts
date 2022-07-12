//
//  UserEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

public struct UserEntity: Codable {
    public let id: Int
    public let name, username, email: String
    public let address: AddressEntity
    public let phone, website: String
    public let company: CompanyEntity
}
