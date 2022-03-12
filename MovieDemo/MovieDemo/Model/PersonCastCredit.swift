//
//  PersonCastCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct PersonCastCredit: Codable {
    var character: String?
    var movie: Movie?
    
    enum CodingKeys: String, CodingKey {
        case character
    }
    
    init(from decoder: Decoder) throws {
        do {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        character = try container.decode(String.self, forKey: .character)
        
        movie = try Movie(from: decoder)
        } catch {
            print(error)
        }
    }
    
}

extension PersonCastCredit {
    static func sortByRelease(lhs: PersonCastCredit, rhs: PersonCastCredit) -> Bool {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 100
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        
        return lhs.movie?.releaseDate ?? futureDate > rhs.movie?.releaseDate ?? futureDate
    }
}
