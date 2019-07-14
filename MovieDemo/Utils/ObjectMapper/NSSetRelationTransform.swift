//
//  CoreDataRelationTransform.swift
//  test
//
//  Created by Oscar Vernis on 7/7/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

open class NSSetRelationTransform<T: Mappable>: TransformType {
    public typealias Object = NSSet
    public typealias JSON = [[String : Any]]
    
    private let modelClass: T.Type
    
    public func transformFromJSON(_ value: Any?) -> NSSet? {
        guard let array = value as? [[String : Any]] else {
            return nil
        }
        
        let mappedArray = Mapper<T>().mapArray(JSONArray: array)
        return NSSet(array: mappedArray)
    }
    
    public func transformToJSON(_ value: NSSet?) -> [[String : Any]]? {
        guard let array = value?.allObjects as? [T] else {
            return nil
        }
        
        let JSONDict = array.toJSON()
        
        return JSONDict
    }
    
    public init(model: T.Type) {
        self.modelClass = model
    }    
}
