//
//  DomainConvertible.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

protocol DomainConvertible {
    associatedtype DomainType
    
    var asDomain: DomainType { get }
}
