//
//  CrewCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation

struct CrewCredit {
    var id: Int!
    var name: String!
    var department: String?
    var gender: Int?
    var job: String?
    var profilePath: String?
}

//MARK: - Utils
extension CrewCredit: Codable {}

extension CrewCredit: Hashable {
   func hash(into hasher: inout Hasher) {
        hasher.combine(job)
        hasher.combine(id)
    }
}

extension CrewCredit: Equatable {
    static func == (lhs: CrewCredit, rhs: CrewCredit) -> Bool {
        return lhs.id == lhs.id
    }
    
}
