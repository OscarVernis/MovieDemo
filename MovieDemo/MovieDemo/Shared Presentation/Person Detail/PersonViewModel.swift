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

    var castCredits = [PersonCastCreditViewModel]()
    var crewCredits = [PersonCrewCreditViewModel]()
    
    var departments: [String] = []
    var departmentCrewCredits: [String: [PersonCrewCreditViewModel]] = [:]
    
    var information: [[String: String]] = []
    
    var popularMovies = [MovieViewModel]()
        
    init(person: Person) {
        self.person = person
        updateDetails()
    }

    func updateDetails() {
        updateCastCredits()
        updateCrewCredits()
        updatePopularMovies()
        updateInformation()
    }
    
}
    
//MARK: - Properties
extension PersonViewModel {
    var id: Int {
        person.id
    }
    
    var name: String {
        person.name
    }
    
    var knownForDepartment: String? {
        person.knownForDepartment
    }
    
    var birthday: Date? {
        person.birthday
    }
    
    var deathday: Date? {
        person.deathday
    }
    
    var biography: String? {
        person.biography
    }
    
    var placeOfBirth: String? {
        person.placeOfBirth
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

    func credits(for department: String) -> [PersonCrewCreditViewModel] {
        departmentCrewCredits[department] ?? []
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
        
        departments = NSOrderedSet(array: crewCredits.compactMap(\.department)).array as! [String]
        //Put known for department first
        if let knownFor = knownForDepartment,
           let index = departments.firstIndex(of: knownFor),
           index != 0
        {
            let d = departments.remove(at: index)
            departments.insert(d, at: 0)
        }
        
        departmentCrewCredits = [:]
        for department in departments {
            let credits = crewCredits.filter { $0.department == department }
            departmentCrewCredits[department] = credits
        }
    }
    
    fileprivate func updatePopularMovies() {
        var credits: [Movie] = []
        
        if departments.contains(knownForDepartment ?? "") {
            if let crewCredits = person.crewCredits {
                credits.append(contentsOf: crewCredits.filter({ $0.department == knownForDepartment }).compactMap { $0.movie } )
            }
        } else {
            if let castCredits = person.castCredits {
                credits.append(contentsOf: castCredits.compactMap { $0.movie } )
            }
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
    
    func updateInformation() {
        information.removeAll()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        
        if let knownForDepartment, !knownForDepartment.isEmpty {
            information.append(["Known For": knownForDepartment])
        }
        
        let creditsCount = crewCredits.count + castCredits.count
        if creditsCount > 0 {
            information.append(["Credits": "\(creditsCount)"])
        }
        
        if let gender = person.gender {
            information.append(["Gender": gender.string])
        }
        
        if let birthday {
            information.append(["Birthday": dateFormatter.string(from: birthday)])
        }
        
        if let deathday {
            information.append(["Day of Death": dateFormatter.string(from: deathday)])
        }
        
        if let placeOfBirth {
            information.append(["Place of Birth": placeOfBirth])
        }
    }
    
}

extension PersonViewModel: Identifiable, Hashable {
    static func == (lhs: PersonViewModel, rhs: PersonViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
