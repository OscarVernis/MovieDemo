//
//  CoreDataManager.swift
//  test
//
//  Created by Oscar Vernis on 7/3/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import MagicalRecord

class CoreDataManager {
    
    private static var tmpContext: NSManagedObjectContext = {        
        let tmpCtx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        tmpCtx.parent = CoreDataManager.defaultContext()
        
        return tmpCtx
    }()
    
    class func saveToDisk() {
        do {
            try NSManagedObjectContext.mr_default().save()
        } catch {
            return
        } 
                
        NSManagedObjectContext.mr_rootSaving().mr_saveToPersistentStoreAndWait()
    }
    
    class func defaultContext() -> NSManagedObjectContext {
        return NSManagedObjectContext.mr_default()
    }
    
    class func tempContext() -> NSManagedObjectContext {
        return tmpContext
    }
    
}

