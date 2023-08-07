//
//  CodableMovie+Mapping.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension Collection where Element == CodableMovie {
    func toMovies() -> [Movie] {
        map { $0.toMovie() }
    }
}

extension CodableMovie {
    func toMovie() -> Movie {
        var movie = Movie()
        
        movie.id = id
        movie.title = title
        movie.tagline = tagline
        movie.overview = overview
        movie.posterPath = posterPath
        movie.backdropPath = backdropPath
        movie.releaseDate = releaseDate
        movie.runtime = runtime
        movie.voteAverage = voteAverage
        movie.voteCount = voteCount
        movie.cast = credits?.cast?.compactMap { $0.toCastCredit() }
        movie.crew = credits?.crew?.compactMap { $0.toCrewtCredit() }
        movie.recommendedMovies = recommendations?.items.toMovies()
        movie.status = status
        movie.popularity = popularity
        movie.originalLanguage = originalLanguage
        movie.budget = budget
        movie.revenue = revenue
        movie.originalTitle = originalTitle
        movie.productionCountries = productionCountries?.compactMap { $0.iso3166_1 }
        
        if let genres {
            movie.genres = genres.compactMap { MovieGenre(rawValue: $0.id ?? 0) }
        } else if let genreIds {
            movie.genres = genreIds.compactMap { MovieGenre(rawValue: $0 ) }
        }
        
        movie.videos = videos?.results?.compactMap { $0.toMovieVideo() }
        
        movie.favorite = accountStates?.favorite
        movie.userRating = accountStates?.rated?.value
        movie.watchlist = accountStates?.watchlist
        
        var socialLinks = [SocialLink]()
        if let instagramID = externalIds?.instagramID, !instagramID.isEmpty {
            socialLinks.append(.instagram(username: instagramID))
        }
        
        if let twitterID = externalIds?.twitterID, !twitterID.isEmpty {
            socialLinks.append(.twitter(username: twitterID))
        }
        
        if let facebookID = externalIds?.facebookID, !facebookID.isEmpty {
            socialLinks.append(.facebook(username: facebookID))
        }
        
        if let homepage = homepage, let url = URL(string: homepage) {
            socialLinks.append(.homepage(url: url))
        }
        
        movie.socialLinks = socialLinks
        
        return movie
    }
}

extension CodableCast {
    func toCastCredit() -> CastCredit {
        var castCredit = CastCredit()
        
        castCredit.name = name
        castCredit.castId = castId
        castCredit.character = character
        castCredit.gender = gender
        castCredit.id = id
        castCredit.order = order
        castCredit.profilePath = profilePath
        
        return castCredit
    }
}

extension CodableCrew {
    func toCrewtCredit() -> CrewCredit {
        var crewCredit = CrewCredit()
        
        crewCredit.id = id
        crewCredit.name = name
        crewCredit.department = department
        crewCredit.gender = gender
        crewCredit.job = job
        crewCredit.profilePath = profilePath
        
        return crewCredit
    }
}

extension CodableVideo {
    func toMovieVideo() -> MovieVideo {
        var video = MovieVideo()
    
        video.key = key
        video.name = name
        video.type = type
        
        return video
    }
}
