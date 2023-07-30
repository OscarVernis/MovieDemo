//
//  PersonCastCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct PersonCastCredit {
    var id: Int
    var character: String?
    var order: Int
    var movie: Movie?
    
    init(id: Int, order: Int = .max) {
        self.id = id
        self.order = order
    }
}

//MARK: - Utils
extension PersonCastCredit {
    static func sortByRelease(lhs: PersonCastCredit, rhs: PersonCastCredit) -> Bool {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 100
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        
        return lhs.movie?.releaseDate ?? futureDate > rhs.movie?.releaseDate ?? futureDate
    }
}
