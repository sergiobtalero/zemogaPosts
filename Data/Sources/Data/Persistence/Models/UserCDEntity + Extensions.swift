//
//  UserCDEntity + Extensions.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

extension UserCDEntity: DomainConvertible {
    var asDomain: User {
        User(id: Int(id),
             name: name ?? "",
             username: username ?? "",
             email: email ?? "",
             address: address?.asDomain,
             phone: phone ?? "",
             website: website ?? "",
             company: company?.asDomain)
    }
}

extension AddressCDEntity: DomainConvertible {
    var asDomain: Address {
        Address(street: street ?? "",
                suite: suite ?? "",
                city: city ?? "",
                zipcode: zipcode ?? "",
                lat: lat,
                lng: lng)
    }
}

extension CompanyCDEntity: DomainConvertible {
    var asDomain: Company {
        Company(name: name ?? "",
                catchPhrase: catchPhrase ?? "",
                bs: bs ?? "")
    }
}
