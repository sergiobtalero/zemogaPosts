//
//  PersistenceManagerInterface.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Domain

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
    
    
    func createUser(from entity: UserEntity) -> UserCDEntity
    func createAddress(from entity: AddressEntity) -> AddressCDEntity
    func createCompany(from entity: CompanyEntity) -> CompanyCDEntity
    func createComment(from entity: CommentEntity) -> CommentCDEntity
    
    func getPosts() throws -> [PostCDEntity]
    func getPost(id: Int32) throws -> Post
    func getUser(id: Int) throws -> UserCDEntity
    
    func updatePost(id: Int32, user: UserCDEntity) throws
    func updatePost(id: Int32, comments: [CommentCDEntity]) throws
    func updateFavorite(newValue: Bool, postId: Int32) throws
    
    func deleteAll() throws
}
