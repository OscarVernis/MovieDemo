//
//  MovieViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MovieViewModel {
    private var movie: Movie
    
    private let movieService = MovieDBService()
    private var isFetching = false
    var didUpdate: ((Error?) -> Void)?
    
    //Stores basic info about the movie
    var infoArray = [[String : String]]()
    
    //Stores only the first 8 credits from the cast
    var topCast = [CastCreditViewModel]()
    
    //Stores only the credits with jobs inclueded in the topCrewJobs array
//    var topCrew = [[String : String]]()
    var topCrew = [CrewCreditViewModel]()
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func updateMovie(_ movie: Movie) {
        self.movie = movie
        updateTopCrew()
        updateTopCast()
        updateInfoArray()
    }
    
}

//MARK:- Fetch Movie Details
extension MovieViewModel {
    func refresh() {
        fetchMovieDetails()
    }
    
    private func fetchMovieDetails() {
        var sessionId: String? = nil
        if SessionManager.shared.isLoggedIn {
            sessionId = SessionManager.shared.sessionId
        }
        
        movieService.fetchMovieDetails(movieId: movie.id!, sessionId: sessionId) { [weak self] movie, error in
            guard let self = self else { return }
            
            if error != nil {
                self.didUpdate?(error)
            }
            
            if let movie = movie {
                self.updateMovie(movie)
                self.didUpdate?(nil)
            }
        }
    }
    
}

//MARK:- Properties
extension MovieViewModel {
    var id: Int {
        return movie.id
    }
    
    var title: String {
        return movie.title
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
        
    func genres(separatedBy separator: String = ", ") -> String {
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
    
    var releaseDate: String? {
        let dateFormatter = DateFormatter(withFormat: "MMMM dd, yyyy", locale: "en_US")
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : nil
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
    
    var status: String? {
        return movie.status
    }
    
    var originalLanguage: String? {
        guard let languageCode = movie.originalLanguage else { return nil }
        
        return Locale.current.localizedString(forLanguageCode: languageCode)
    }
    
    var budget: String? {
        guard let budget = movie.budget, budget > 0 else { return nil }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        return currencyFormatter.string(from: NSNumber(value: budget))
    }
    
    var revenue: String? {
        guard let revenue = movie.revenue, revenue > 0 else { return nil }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        return currencyFormatter.string(from: NSNumber(value: revenue))
    }
    
    var cast: [CastCreditViewModel] {
        return movie.cast?.compactMap { CastCreditViewModel(castCredit: $0) } ?? [CastCreditViewModel]()

    }
    
    var crew: [CrewCreditViewModel] {
        return movie.crew?.compactMap { CrewCreditViewModel(crewCredit: $0) } ?? [CrewCreditViewModel]()
    }
    
    var recommendedMovies: [Movie] {
        return movie.recommendedMovies ?? [Movie]()
    }
    
}

//MARK:- User States
extension MovieViewModel {
    var favorite: Bool {
        return movie.favorite
    }
    
    var rated: Bool {
    return movie.rated
    }
    
    var watchlist: Bool {
        return movie.watchlist
    }
}

//MARK:- Generated data
extension MovieViewModel {
    private func updateInfoArray() {
        var info = [[String : String]]()
        
        if let releaseDate = releaseDate {
            info.append(["Release Date": releaseDate])
        }
        
        if let status = status {
            info.append(["Status": status])
        }
        
        if let originalLanguage = originalLanguage {
            info.append(["Original Language": originalLanguage])
        }

        if let budget = budget {
            info.append(["Budget": budget])
        }
        
        if let revenue = revenue {
            info.append(["Revenue": revenue])
        }
        
        infoArray = info
    }
    
    private func updateTopCast() {
        guard let cast = movie.cast else { return }
        
        topCast = Array(cast.prefix(8)).compactMap { CastCreditViewModel(castCredit: $0) }
    }
    
    private func updateTopCrew() {
        guard let crew = movie.crew else { return }

        topCrew = CrewCreditViewModel.crewWithTopJobs(credits: crew)
    }
}

