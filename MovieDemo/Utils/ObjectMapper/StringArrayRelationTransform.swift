//
//  StringArrayRelationTransform.swift
//  test
//
//  Created by Oscar Vernis on 7/8/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

open class StringArrayRelationTransform<T: Mappable>: TransformType {
    public typealias Object = NSSet
    public typealias JSON = [String]
    
    private let modelClass: T.Type
    
    public func transformFromJSON(_ value: Any?) -> NSSet? {
        guard let array = value as? [String] else {
            return nil
        }
        
        let galleryData = array.map { ["value": $0] }
        
        let mappedArray = Mapper<T>().mapArray(JSONArray: galleryData)
        return NSSet(array: mappedArray)
    }
    
    public func transformToJSON(_ value: NSSet?) -> [String]? {
        guard let array = value?.allObjects as? [T] else {
            return nil
        }
        
        let jsonDict = array.toJSON()
        let stringArray = jsonDict.flatMap { $0.values }
        
        return stringArray as? [String]
    }
    
    public init(model: T.Type) {
        self.modelClass = model
    }
}
