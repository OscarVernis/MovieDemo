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
        "Story",
        "Screenplay",
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
    
    var ratingString: String {
        if isRatingAvailable {
            return "\(percentRating)"
        } else {
            return "NR"
        }
    }
    
    var percentRating: UInt {
        return  UInt((movie.voteAverage ?? 0) * 10)
    }
        
    func genresString(separatedBy separator: String = ", ") -> String {
        let genres = movie.genres?.map { $0.string() } ?? []
        let genresString = genres.joined(separator: separator)
        
        return genresString
    }
    
    var runtime: String? {
        guard let runtime = movie.runtime, runtime > 0 else { return nil }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        //Runtime returned from the service is in minutes, so we have to convert it to seconds
        guard let formattedString = formatter.string(from: Double(runtime * 60)) else { return nil }
        
        return formattedString
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
    
    //Stores only the first 8 credits from the cast
    var topCast = [CastCredit]()
    
    mutating func updateTopCast() {
        guard let cast = movie.cast else { return }
        
        topCast = Array(cast.prefix(8))
    }
    
    //Stores only the credits with jobs inclueded in the topCrewJobs array
    var topCrew = [CrewCredit]()
    
    mutating func updateTopCrew() {
        guard let crew = movie.crew else { return }
        
        var filteredCrew = [CrewCredit]()
        for job in topCrewJobs {
            let crewWithJob = crew.filter { crewCredit in
                crewCredit.job == job && !filteredCrew.contains { filteredCrewCredit in
                    filteredCrewCredit.id == crewCredit.id
                }
            }
            filteredCrew.append(contentsOf: crewWithJob)
        }

        topCrew = filteredCrew
    }
    
    //Returns a job string including all of the job credits by the same person
    func crewCreditJobString(crewCreditId: Int) -> String {
        let jobs = crew.compactMap { crew in
            crew.id == crewCreditId ? crew.job : nil
        }
                
        let jobsString = jobs.joined(separator: ", ")
        
        return jobsString
    }
    
}
