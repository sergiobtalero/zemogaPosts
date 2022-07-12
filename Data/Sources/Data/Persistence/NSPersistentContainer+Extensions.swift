//
//  NSPersistentContainer+Extensions.swift
//  
//
//  Created by Sergio Bravo on 12/07/22.
//

import CoreData

extension NSPersistentContainer {
    static let main: NSPersistentContainer = {
        let modelName = "ZemogaPosts"
        
        guard let url = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: url)else {
            fatalError("Could not load managed object model")
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistence store with error: \(error.localizedDescription)")
            }
            
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
        
        return container
    }()
}
