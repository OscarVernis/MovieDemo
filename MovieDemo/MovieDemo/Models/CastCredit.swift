//
//  CastCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation

struct CastCredit {
    var name: String!
    var castId: Int?
    var character: String?
    var gender: Int?
    var id: Int!
    var order: Int?
    var profilePath: String?
    
}

//MARK: - Codable
extension CastCredit: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case castId = "cast_id"
        case character
        case gender
        case id
        case order
        case profilePath = "profile_path"
    }
}

//MARK: - Utils
extension CastCredit: Hashable {
   func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(order)
    }
}

extension CastCredit: Equatable {
    static func == (lhs: CastCredit, rhs: CastCredit) -> Bool {
        return lhs.id == lhs.id
    }
    
}
