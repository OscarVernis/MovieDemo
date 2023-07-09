//
//  PersonViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class PersonViewModel {
    private var person: Person

    var castCredits = [PersonCastCreditViewModel]()
    var crewCredits = [PersonCrewCreditViewModel]()

    var popularMovies = [MovieViewModel]()
        
    init(person: Person) {
        self.person = person
        updateInfo()
    }

    func updateInfo() {
        updateCastCredits()
        updateCrewCredits()
        updatePopularMovies()
    }
    
}
    
//MARK: - Properties
extension PersonViewModel {
    var id: Int {
        return person.id
    }
    
    var name: String {
        return person.name
    }
    
    var knownForDepartment: String? {
        return person.knownForDepartment
    }
    
    var birthday: Date? {
        return person.birthday
    }
    
    var deathday: Date? {
        return person.deathday
    }
    
    var biography: String? {
        return person.biography
    }
    
    var placeOfBirth: String? {
        return person.placeOfBirth
    }

    var profileImageURL: URL? {
        guard let pathString = person.profilePath else { return nil }
        
        return MovieServiceImageUtils.profileImageURL(forPath: pathString, size: .original)
    }
    
    var knownForMovies: String? {
        return person.knownForMovies?
            .sorted(by: Movie.sortByPopularity)
            .prefix(3)
            .compactMap(\.title)
            .joined(separator: ", ")
    }
    
    var crewJobs: [String] {
        crewCredits.compactMap(\.job)
    }
    
    func credits(for job: String) -> [PersonCrewCreditViewModel] {
        return crewCredits.filter { $0.job == job }
    }
    
    fileprivate func updateCastCredits() {
        guard let credits = person.castCredits else { return }
        
        castCredits = credits
            .sorted(by: PersonCastCredit.sortByRelease)
            .compactMap { PersonCastCreditViewModel(personCastCredit: $0) }
    }
    
    fileprivate func updateCrewCredits() {
        guard let credits = person.crewCredits else { return }
        
        crewCredits = credits
            .sorted(by: PersonCrewCredit.sortByRelease)
            .compactMap { PersonCrewCreditViewModel(personCrewCredit: $0) }
    }
    
    fileprivate func updatePopularMovies() {
        var credits = [Movie]()
        
        if let castCredits = person.castCredits {
            credits.append(contentsOf: castCredits.compactMap { $0.movie } )
        }
        
        if let crewCredits = person.crewCredits {
            credits.append(contentsOf: crewCredits.compactMap { $0.movie } )
        }
        
        var filteredMovies = [Movie]()
        for movie in credits where !filteredMovies.contains(movie)  {
            filteredMovies.append(movie)
        }
        
        popularMovies = filteredMovies
            .sorted(by: Movie.sortByPopularity)
            .prefix(8)
            .compactMap { MovieViewModel(movie: $0) }
    }
    
}
