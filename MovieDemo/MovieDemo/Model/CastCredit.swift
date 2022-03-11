//
//  Credit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation

class CastCredit: Codable {
    var name: String!
    var castId: Int?
    var character: String?
    var creditId: Int?
    var gender: Int?
    var id: Int!
    var order: Int?
    var profilePath: String?
}

extension CastCredit: Hashable {
   func hash(into hasher: inout Hasher) {
        hasher.combine(creditId)
        hasher.combine(order)
    }
}

extension CastCredit: Equatable {
    static func == (lhs: CastCredit, rhs: CastCredit) -> Bool {
        return lhs.creditId == lhs.creditId
    }
    
}
