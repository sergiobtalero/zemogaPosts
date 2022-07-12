//
//  PersistenceManagerInterface.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation

enum PersistenceManagerError: Error {
    case operationFailed
    case missingRecord
}

public protocol PersistenceManagerInterface {
    func save() throws
    func rollback()
    
    func createPost(userId: Int32,
                    id: Int32,
                    title: String,
                    body: String) throws
}
