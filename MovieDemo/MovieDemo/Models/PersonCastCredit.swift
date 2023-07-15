//
//  PersonCastCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct PersonCastCredit {
    var character: String?
    var movie: Movie?
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
