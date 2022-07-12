//
//  AddressEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

public struct AddressEntity: Codable {
    public let street, suite, city, zipcode: String
    public let geo: GeoEntity
}

extension AddressEntity: DomainConvertible {
    var asDomain: Address {
        Address(street: street,
                suite: suite,
                city: city,
                zipcode: zipcode,
                lat: Double(geo.lat),
                lng: Double(geo.lng))
    }
}
