//
//  PersonCrewCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct PersonCrewCredit {
    var job: String?
    var movie: Movie?
}

//MARK: - Utils
extension PersonCrewCredit {
    static func sortByRelease(lhs: PersonCrewCredit, rhs: PersonCrewCredit) -> Bool {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 100
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        
        return lhs.movie?.releaseDate ?? futureDate > rhs.movie?.releaseDate ?? futureDate
    }
}
