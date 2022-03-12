//
//  Credit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation

struct CastCredit: Codable {
    var name: String!
    var castId: Int?
    var character: String?
    var creditId: Int?
    var gender: Int?
    var id: Int!
    var order: Int?
    var profilePath: String?
    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case castId = "cast_id"
//        case character
//        case creditId = "credit_id"
//        case gender
//        case id
//        case order
//        case profilePath = "profile_path"
//    }
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
