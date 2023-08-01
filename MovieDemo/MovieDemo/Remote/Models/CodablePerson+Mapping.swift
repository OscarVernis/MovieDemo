//
//  CodablePerson+Mapping.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension CodablePerson {
    func toPerson() -> Person {
        var person = Person()
        
        person.id = id
        person.name = name
        person.knownForDepartment = knownForDepartment
        person.birthday = birthday
        person.deathday = deathday
        person.biography = biography
        person.placeOfBirth = placeOfBirth
        person.profilePath = profilePath
        person.knownForMovies = knownForMovies?.toMovies()
        person.castCredits = movieCredits?.cast?.compactMap { $0.toPersonCastCredit() }
        person.crewCredits = movieCredits?.crew?.compactMap { $0.toPersonCrewCredit() }
        
        if let gender {
            person.gender = Person.Gender(rawValue: gender)
        }
        
        if let homepage {
            person.homepage = URL(string: homepage)
        }
        
        var socialLinks = [Person.SocialLinks]()
        if let instagramID = externalIds?.instagramID, !instagramID.isEmpty {
            socialLinks.append(.instagram(username: instagramID))
        }
        
        if let twitterID = externalIds?.twitterID, !twitterID.isEmpty {
            socialLinks.append(.twitter(username: twitterID))
        }
        
        if let facebookID = externalIds?.facebookID, !facebookID.isEmpty {
            socialLinks.append(.facebook(username: facebookID))
        }
        
        if let tiktokID = externalIds?.tiktokID, !tiktokID.isEmpty {
            socialLinks.append(.tiktok(username: tiktokID))
        }
        
        if let youtubeID = externalIds?.youtubeID, !youtubeID.isEmpty {
            socialLinks.append(.youtube(username: youtubeID))
        }
        
        person.socialLinks = socialLinks
        
        return person
    }
}

extension CodableCastCredit {
    func toPersonCastCredit() -> PersonCastCredit {
        var credit = PersonCastCredit(id: id)
        
        credit.character = character
        credit.movie = movie?.toMovie()
        
        return credit
    }
}

extension CodableCrewCredit {
    func toPersonCrewCredit() -> PersonCrewCredit {
        var credit = PersonCrewCredit(id: id)
        
        credit.job = job
        credit.department = department
        credit.movie = movie?.toMovie()
        
        return credit
    }
}
