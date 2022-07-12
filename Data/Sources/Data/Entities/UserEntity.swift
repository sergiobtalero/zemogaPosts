//
//  UserEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

struct UserEntity: Codable {
    let id: Int
    let name, username, email: String
    let address: AddressEntity
    let phone, website: String
    let company: CompanyEntity
}
