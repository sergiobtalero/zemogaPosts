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
//    func createCounter(id: String,
//                       title: String,
//                       count: Int) throws
//    func fetchAllCounters() throws -> [CounterEntity]
//    func updateCounterCount(id: String,
//                            newCount: Int32) throws
//    func updateCounterSyncState(id: String,
//                                syncState: Bool) throws
//    func updateCounter(id: String,
//                       newId: String) throws
//    func deleteCounter(id: String) throws
}
