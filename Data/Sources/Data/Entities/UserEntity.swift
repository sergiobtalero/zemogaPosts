//
//  UserEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

public struct UserEntity: Codable {
    public let id: Int
    public let name, username, email: String
    public let address: AddressEntity
    public let phone, website: String
    public let company: CompanyEntity
}

extension UserEntity: DomainConvertible {
    var asDomain: User {
        User(id: id,
             name: name,
             username: username,
             email: email,
             address: address.asDomain,
             phone: phone,
             website: website,
             company: company.asDomain)
    }
}
