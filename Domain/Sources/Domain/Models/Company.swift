//
//  Company.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

public struct Company {
    public let name: String
    public let catchPhrase: String
    public let bs: String
    
    // MARK: - Initializer
    public init(name: String,
                catchPhrase: String,
                bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
