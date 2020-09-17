//
//  MovieViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct MovieViewModel {
    //Used to filter the top crew jobs to show on the detail
    private let topCrewJobs = [
        "Director",
        "Writer",
        "Producer",
        "Editor",
        "Director of Photography",
        "Original Music Composer"
    ]
    
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    mutating func updateMovie(_ movie: Movie) {
        self.movie = movie
        updateTopCrew()
        updateTopCast()
    }
    
    var id: Int? {
        return movie.id
    }
    
    var title: String {
        return movie.title ?? ""
    }
    
    var overview: String {
        return movie.overview ?? ""
    }
    
    var isRatingAvailable: Bool {
        return !(movie.voteCount == nil || movie.voteCount == 0 || movie.voteAverage == nil)
    }
    
    var rating: Float {
        return movie.voteAverage ?? 0
    }
    
    var genresString: String {
        let genres = movie.genres?.map { $0.string() } ?? []
        let genresString = genres.joined(separator: ", ")
        
        return genresString
    }
    
    var releaseYear: String {
        let dateFormatter = DateFormatter(withFormat: "yyyy", locale: "en_US")
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
    }
    
    var releaseDateWithoutYear: String {
        let dateFormatter = DateFormatter(withFormat: "MMM dd", locale: "en_US")
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
    }
    
    func backdropImageURL(size: MovieDBService.BackdropSize = .w300) -> URL? {
        let url = (movie.backdropPath != nil) ? MovieDBService.backdropImageURL(forPath:movie.backdropPath!, size: size) : nil
        return url
    }
    
    func posterImageURL(size: MovieDBService.MoviePosterSize = .original) -> URL? {
        let url = (movie.posterPath != nil) ? MovieDBService.posterImageURL(forPath:movie.posterPath!, size: size) : nil
        return url
    }
    
    var cast: [CastCredit] {
        get {
            return movie.cast ?? [CastCredit]()
        }
        set(cast) {
            movie.cast = cast
            updateTopCast()
        }
    }
    
    var crew: [CrewCredit] {
        get {
            return movie.crew ?? [CrewCredit]()
        }
        set(crew) {
            movie.crew = crew
            updateTopCrew()
        }
    }
    
    var recommendedMovies: [Movie] {
        get {
            return movie.recommendedMovies ?? [Movie]()
        }
        set(movies) {
            movie.recommendedMovies = movies
        }
    }
    
    var topCrew = [CrewCredit]()
    
    mutating func updateTopCrew() {
        guard let crew = movie.crew else { return }
        
        var filteredCrew = [CrewCredit]()
        for job in topCrewJobs {
            let crewWithJob = crew.filter { $0.job == job }
            filteredCrew.append(contentsOf: crewWithJob)
        }
        
        topCrew = filteredCrew
    }
    
    var topCast = [CastCredit]()
    
    mutating func updateTopCast() {
        guard let cast = movie.cast else { return }
        
        topCast = Array(cast.prefix(8))
    }
    
}
