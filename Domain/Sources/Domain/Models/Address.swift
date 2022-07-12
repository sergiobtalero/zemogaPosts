//
//  Address.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

public struct Address {
    public let street: String
    public let suite: String
    public let city: String
    public let zipcode: String
    public let lat: Double?
    public let lng: Double?
    
    // MARK: - Initializer
    public init(street: String,
                suite: String,
                city: String,
                zipcode: String,
                lat: Double?,
                lng: Double?) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.lat = lat
        self.lng = lng
    }
}
