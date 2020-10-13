//
//  PersonViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class PersonViewModel {
    private var person: Person
        
    private let movieService = MovieDBService()
    private var isFetching = false
    var didUpdate: ((Error?) -> Void)?
    
    var castCredits = [PersonCastCreditViewModel]()
    var popularMovies = [MovieViewModel]()
    
    init(person: Person) {
        self.person = person
    }
    
    func updatePerson(_ person: Person) {
        self.person = person
        updateCastCredits()
        updatePopularMovies()
    }
    
}

//MARK:- Fetch Person Details
extension PersonViewModel {
    func refresh() {
        fetchPersonDetails()
    }
    
    private func fetchPersonDetails() {
        movieService.fetchPersonDetails(personId: person.id) { [weak self] person, error in
            guard let self = self else { return }

            if error != nil {
                self.didUpdate?(error)
                return
            }
            
            if let person = person {
                self.updatePerson(person)
                self.didUpdate?(nil)
            }
        }
        
    }
    
}
    
//MARK:- Properties
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
        
        return MovieDBService.profileImageURL(forPath: pathString, size: .original)
    }
        
    fileprivate func updateCastCredits() {
        guard var credits = person.castCredits else { return }
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 100
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        credits.sort { (person1, person2) -> Bool in
            person1.releaseDate ?? futureDate > person2.releaseDate ?? futureDate
        }
        
        castCredits = credits.compactMap { PersonCastCreditViewModel(personCastCredit: $0) }
    }
    
    fileprivate func updatePopularMovies() {
        guard var credits = person.castCredits else { return }
        credits.sort {
            $0.voteCount ?? 0 > $1.voteCount ?? 0
        }
        let viewModels = credits.prefix(8).compactMap { MovieViewModel(movie: $0) }
        
        popularMovies = viewModels
    }
    
}
