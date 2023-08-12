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

    var credits = [PersonCreditViewModel]()
    
    var departments: [String] = []
    var departmentCredits: [String: [PersonCreditViewModel]] = [:]
    
    var information: [[String: String]] = []
    
    var popularMovies = [MovieViewModel]()
        
    init(person: Person) {
        self.person = person
        updateDetails()
    }

    func updateDetails() {
        updateCredits()
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
    
    var homepage: URL? {
        person.homepage
    }
    
    var socialLinks: [SocialLink] {
        person.socialLinks
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
    
    func localizedDepartment(_ department: String?) -> String {
        guard let department else { return "" }
        
        return CrewDepartment(rawValue: department)?.localized ?? department
    }
    
    func credits(for department: String) -> [PersonCreditViewModel] {
        departmentCredits[department] ?? []
    }
    
    fileprivate func updateCredits() {
        var allCredits = [PersonCreditViewModel]()
        let castCredits = person.castCredits?.compactMap(PersonCreditViewModel.init(castCredit:)) ?? []
        allCredits.append(contentsOf: castCredits)
        let crewCredits = person.crewCredits?.compactMap(PersonCreditViewModel.init(crewCredit:)) ?? []
        allCredits.append(contentsOf: crewCredits)
        
        allCredits.sort(by: PersonCreditViewModel.sortByRelease)
        
        let uniqueDepartments = Set(allCredits.compactMap(\.department)).map { localizedDepartment($0) }
                
        departmentCredits = [:]
        for department in uniqueDepartments {
            let credits = allCredits.filter { department == localizedDepartment($0.department) }
            departmentCredits[department] = credits
        }
        
        departments = uniqueDepartments.sorted {
            departmentCredits[$0]?.count ?? 0 > departmentCredits[$1]?.count ?? 0
        }

    }
    
    fileprivate func updatePopularMovies() {
        var credits: [Movie] = []
                
        if knownForDepartment != CrewDepartment.Acting.rawValue, departments.contains(knownForDepartment ?? "") {
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
            let localizedDepartment = CrewDepartment(rawValue: knownForDepartment)?.localized ?? knownForDepartment
            information.append([PersonString.KnownFor.localized: localizedDepartment])
        }
        
        let creditsCount = credits.count
        if creditsCount > 0 {
            information.append([PersonString.Credits.localized: "\(creditsCount)"])
        }
        
        if let gender = person.gender {
            information.append([PersonString.Gender.localized: gender.string])
        }
        
        if let birthday {
            var birthdayString = dateFormatter.string(from: birthday)
            if deathday == nil {
                let age = birthday.distanceInYears(to: .now)
                birthdayString += " (\(age) " + PersonString.YearsOld.localized + ")"
            }
        
            information.append([PersonString.Birthday.localized: birthdayString])
        }
        
        if let deathday {
            var deathdayString = dateFormatter.string(from: deathday)
            if let birthday {
                let age = birthday.distanceInYears(to: deathday)
                deathdayString += " (\(age) " + PersonString.YearsOld.localized + ")"
            }
            
            information.append([PersonString.Deathday.localized: deathdayString])
        }
        
        if let placeOfBirth {
            information.append([PersonString.PlaceOfBirth.localized: placeOfBirth])
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
