//
//  CompanyEntity.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

public struct CompanyEntity: Codable {
    public let name, catchPhrase, bs: String
}

extension CompanyEntity: DomainConvertible {
    var asDomain: Company {
        Company(name: name,
                catchPhrase: catchPhrase,
                bs: bs)
    }
}
