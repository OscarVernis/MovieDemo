//
//  CrewCredit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation

struct CrewCredit: Codable {
    var id: Int!
    var name: String!
    var creditId: Int?
    var department: String?
    var gender: Int?
    var job: String?
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case creditId = "credit_id"
        case department
        case gender
        case job
        case profilePath = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        creditId = try container.decodeIfPresent(Int.self, forKey: .creditId)
        department = try container.decodeIfPresent(String.self, forKey: .department)
        gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        job = try container.decodeIfPresent(String.self, forKey: .job)
        profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
    }
}

extension CrewCredit: Hashable {
   func hash(into hasher: inout Hasher) {
        hasher.combine(job)
        hasher.combine(creditId)
    }
}

extension CrewCredit: Equatable {
    static func == (lhs: CrewCredit, rhs: CrewCredit) -> Bool {
        return lhs.creditId == lhs.creditId
    }
    
}