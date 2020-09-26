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
    var topCrew = [CrewCreditViewModel]()
    
    //Store the movie videos
    var videos = [MovieVideoViewModel]()
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func updateMovie(_ movie: Movie) {
        self.movie = movie
        updateTopCrew()
        updateTopCast()
        updateInfoArray()
        updateVideos()
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
                return
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
            return NSLocalizedString("NR", comment: "")
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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long

        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : nil
    }
    
    var releaseYear: String {
        let dateFormatter = DateFormatter(withFormat: "yyyy", locale: Locale.current.identifier)
        
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
    }
    
    var releaseDateWithoutYear: String {
        let dateFormatter = DateFormatter(withFormat: "MMM dd", locale: Locale.current.identifier)
        
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!).capitalized : ""
    }
    
    func backdropImageURL(size: MovieDBService.BackdropSize = .w300) -> URL? {
        let url = (movie.backdropPath != nil) ? MovieDBService.backdropImageURL(forPath:movie.backdropPath!, size: size) : nil
        return url
    }
    
    func posterImageURL(size: MovieDBService.MoviePosterSize = .original) -> URL? {
        let url = (movie.posterPath != nil) ? MovieDBService.posterImageURL(forPath:movie.posterPath!, size: size) : nil
        return url
    }
    
    var trailerURL: URL? {
        guard let trailer = movie.videos?.last(where: { $0.type == "Trailer" }) else { return nil }        
        let videoViewModel = MovieVideoViewModel(video: trailer)
        return videoViewModel.youtubeURL
    }
    
    var youtubeKey: String? {
        guard let trailer = movie.videos?.last else { return nil }

        return trailer.key
    }
    
    var status: String? {
        return movie.status
    }
    
    var originalLanguage: String? {
        guard let languageCode = movie.originalLanguage else { return nil }
        
        return Locale.current.localizedString(forLanguageCode: languageCode)?.capitalized
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
    
    var userRating: UInt {
        return UInt(movie.userRating)
    }

    var percentUserRating: UInt {
        return UInt(movie.userRating * 10)
    }
    
    var userRatingString: String {
        if rated {
            return "\(percentUserRating)"
        } else {
            return NSLocalizedString("NR", comment: "")
        }
    }
    
    var watchlist: Bool {
        return movie.watchlist
    }
    
    func markAsFavorite(_ favorite: Bool, completion: @escaping (Bool) -> Void) {
        guard let sessionId = SessionManager.shared.sessionId else {
            completion(false)
            return
        }
        
        movieService.markAsFavorite(favorite, movieId: id, sessionId: sessionId) { [weak self] success, error in
            if success && error == nil {
                self?.movie.favorite = favorite
                completion(success)
            } else {
                completion(false)
            }
        }
    }
    
    func addToWatchlist(_ watchlist: Bool, completion: @escaping (Bool) -> Void) {
        guard let sessionId = SessionManager.shared.sessionId else {
            completion(false)
            return
        }
        
        movieService.addToWatchlist(watchlist, movieId: id, sessionId: sessionId) { [weak self] success, error in
            if success && error == nil {
                self?.movie.watchlist = watchlist
                completion(success)
            } else {
                completion(false)
            }
        }
    }
    
    func rate(_ rating: Int, completion: @escaping (Bool) -> Void) {
        guard let sessionId = SessionManager.shared.sessionId else {
            completion(false)
            return
        }
        
        //ViewModel receives rating as 0 to 100, but service receives 0.5 to 10 in multiples of 0.5
        var adjustedRating:Float = Float(rating) / 10
        adjustedRating = (adjustedRating / 0.5).rounded(.down) * 0.5
        
        if adjustedRating > 10 {
            adjustedRating = 10
        }
        if adjustedRating < 0.5 {
            adjustedRating = 0.5
        }
                
        movieService.rateMovie(adjustedRating, movieId: id, sessionId: sessionId) { [weak self] success, error in
            if success && error == nil {
                self?.movie.userRating = adjustedRating
                self?.movie.watchlist = false //Server removes movie from watchlist when rating
                self?.movie.rated = true
                completion(success)
            } else {
                completion(false)
            }
        }
    }
    
    func deleteRate(completion: @escaping (Bool) -> Void) {
        guard let sessionId = SessionManager.shared.sessionId else {
            completion(false)
            return
        }
        
        movieService.deleteRate(movieId: movie.id, sessionId: sessionId) { [weak self] success, error in
            if success && error == nil {
                self?.movie.rated = false
                completion(success)
            } else {
                completion(false)
            }
        }
    }
    
    
}

//MARK:- Generated data
extension MovieViewModel {
    private func updateInfoArray() {
        var info = [[String : String]]()
        
        if let releaseDate = releaseDate {
            info.append([NSLocalizedString("Release Date", comment: ""): releaseDate])
        }
        
        if let status = status {
            info.append([NSLocalizedString("Status", comment: ""): status])
        }
        
        if let originalLanguage = originalLanguage {
            info.append([NSLocalizedString("Original Language", comment: ""): originalLanguage])
        }

        if let budget = budget {
            info.append([NSLocalizedString("Budget", comment: ""): budget])
        }
        
        if let revenue = revenue {
            info.append([NSLocalizedString("Revenue", comment: ""): revenue])
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
    
    private func updateVideos() {
        guard let videos = movie.videos, videos.count > 1 else { return }
        
        self.videos = videos.map { MovieVideoViewModel(video: $0) }
    }
    
}

