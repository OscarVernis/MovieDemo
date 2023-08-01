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
    case Gender
    case Birthday
    case YearsOld
    case Deathday
    case PlaceOfBirth
    case Female
    case Male
    case NonBinary

    
    var tableName: String { "Person" }
}
