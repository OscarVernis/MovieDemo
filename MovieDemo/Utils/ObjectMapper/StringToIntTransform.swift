//
//  StringToIntTransform.swift
//  test
//
//  Created by Oscar Vernis on 7/7/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

open class StringToIntTransform: TransformType {
    public typealias Object = Int64
    public typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> Int64? {
        if let value = value as? String {
            return Int64(value)
        } else if let value = value as? Int {
            return Int64(value)
        } else {
            return nil
        }
    }
    
    public func transformToJSON(_ value: Int64?) -> String? {
        if let value = value {
            return String(value)
        } else {
            return nil
        }
    }

} 
