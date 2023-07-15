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
