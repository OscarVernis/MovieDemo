//
//  PersonString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum PersonString: String, Localizable, CaseIterable {
    case Acting
    case KnownFor
    case Credits
    case SeeMore
    
    var tableName: String { "Person" }
}
