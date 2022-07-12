//
//  AddressEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

struct AddressEntity: Codable {
    let street, suite, city, zipcode: String
    let geo: GeoEntity
}
