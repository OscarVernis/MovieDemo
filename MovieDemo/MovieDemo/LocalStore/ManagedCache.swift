//
//  ManagedCache.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
public class ManagedCache: NSManagedObject {
    
    static func uniqueInstance(in context: NSManagedObjectContext) -> ManagedCache {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        
        let managedCache =  try? context.fetch(request).first
        if let managedCache = managedCache {
            return managedCache
        } else {
            return ManagedCache(context: context)
        }
        
    }
    
}
