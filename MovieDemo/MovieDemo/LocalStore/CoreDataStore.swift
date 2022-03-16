//
//  CoreDataStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStore {
    static let shared = CoreDataStore()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieDemo")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to initialize Core Data: \(error)")
            }
        }
    }
    
    func fetchAll<T: NSManagedObject>(entity: T.Type) -> [T] {
        let fetchRequest = NSFetchRequest<T>()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return [T]()
        }
    }
    
//    func deleteAll<T: NSManagedObject>(entity: T.type) -> [T] {
//
//    }
    
    func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save Context: \(error)")
        }
    }
    
}
