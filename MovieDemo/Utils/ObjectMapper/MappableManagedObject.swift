//
//  MappableManagedObject.swift
//  test
//
//  Created by Oscar Vernis on 7/10/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import CoreData
import ObjectMapper

open class MappableManagedObject: NSManagedObject, Mappable {
    public func mapping(map: Map) {
        
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        let ctx = CoreDataManager.defaultContext()
        super.init(entity: entity, insertInto: ctx)
    }
    
    required public init?(map: Map) {
        let ctx = CoreDataManager.defaultContext()
        
        let classType = type(of: self)
        let classString = String(describing: classType)
        
        let entity = NSEntityDescription.entity(forEntityName: classString, in: ctx)
        super.init(entity: entity!, insertInto: ctx)
        
    }
}
