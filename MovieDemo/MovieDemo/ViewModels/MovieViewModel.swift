//
//  MovieViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MovieViewModel {
    private var movie: Movie
    
    var service: RemoteMovieDetailsLoader
    
    var userStates: MovieUserStatesViewModel? = nil

    private var isLoading = false
    var didUpdate: ((Error?) -> Void)?
    
    //Stores basic info about the movie
    var infoArray = [[String : String]]()
    
    //Stores only the first 8 credits from the cast
    var topCast = [CastCreditViewModel]()
    
    //Stores only the credits with jobs inclueded in the topCrewJobs array
    var topCrew = [CrewCreditViewModel]()
    
    //Store the movie videos
    var videos = [MovieVideoViewModel]()
    
    private var cancellable: AnyCancellable? = nil
    
    init(movie: Movie, service: RemoteMovieDetailsLoader = RemoteMovieDetailsLoader()) {
        self.movie = movie
        self.service = service
        updateInfo() 
    }
    
    func updateMovie(_ movie: Movie) {
        self.movie = movie
        updateInfo()
    }
    
    func updateInfo() {
        updateTopCrew()
        updateTopCast()
        updateInfoArray()
        updateVideos()
    }
    
    var hasUserStates: Bool {
        return userStates != nil
    }
}

//MARK: - Movie State
extension MovieViewModel {
    var favorite: Bool {
        movie.favorite ?? false
    }
    
    var watchlist: Bool {
        movie.watchlist ?? false
    }
    
    var userRating: Float? {
        movie.userRating
    }
    
    var rated: Bool {
        movie.userRating != nil
    }
    
    func setFavorite(_ isFavorite: Bool) {
        movie.favorite = isFavorite
    }
    
    func setWatchlist(_ isOnWatchlist: Bool) {
        movie.watchlist = isOnWatchlist
    }
    
    func setUserRating(_ rating: Float?) {
        movie.userRating = rating
    }
}

//MARK: - Load Movie Details
extension MovieViewModel {
    func refresh() {
        getMovieDetails()
    }
    
    private func getMovieDetails() {
        cancellable = service.getMovieDetails(movieId: movie.id!)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.didUpdate?(nil)
                case .failure(let error):
                    self?.didUpdate?(error)
                }
            } receiveValue: { [weak self] movie in
                self?.updateMovie(movie)
            }
    }
    
}

//MARK: - Properties
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
        return isRatingAvailable ? "\(percentRating)" : .localized(MovieString.NR)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale.current
        
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
    }
    
    var releaseDateWithoutYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.locale = Locale.current
        
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!).capitalized : ""
    }
    
    func backdropImageURL(size: MovieService.BackdropSize = .w300) -> URL? {
        let url = (movie.backdropPath != nil) ? MovieService.backdropImageURL(forPath:movie.backdropPath!, size: size) : nil
        return url
    }
    
    func posterImageURL(size: MovieService.MoviePosterSize = .original) -> URL? {
        let url = (movie.posterPath != nil) ? MovieService.posterImageURL(forPath:movie.posterPath!, size: size) : nil
        return url
    }
    
    var trailerURL: URL? {
        let videoViewModel: MovieVideoViewModel
        if let trailer = movie.videos?.last(where: { $0.type == "Trailer" }) {
            videoViewModel = MovieVideoViewModel(video: trailer)
        } else {
            if let teaser = movie.videos?.last(where: { $0.type == "Teaser" }) {
                videoViewModel = MovieVideoViewModel(video: teaser)
            } else {
                return nil
            }
        }
        
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
    
    var productionCountries: String? {
        guard let countries = movie.productionCountries?.compactMap({ Locale.current.localizedString(forRegionCode: $0) }),
            countries.count > 0
        else { return nil }
        
        return countries.joined(separator: ", ")
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
    
    var originalTitle: String? {
        return movie.originalTitle
    }
    
    var cast: [CastCreditViewModel] {
        return movie.cast?.compactMap { CastCreditViewModel(castCredit: $0) } ?? [CastCreditViewModel]()

    }
    
    var crew: [CrewCreditViewModel] {
        return movie.crew?.compactMap { CrewCreditViewModel(crewCredit: $0) } ?? [CrewCreditViewModel]()
    }
    
    var recommendedMovies: [MovieViewModel] {
        return movie.recommendedMovies?.compactMap { MovieViewModel(movie: $0) } ?? [MovieViewModel]()
    }
    
}

//MARK: - Generated data
extension MovieViewModel {
    private func updateInfoArray() {
        var info = [[String : String]]()
        if let originalTitle = originalTitle, originalTitle != title {
            info.append([.localized(MovieString.OriginalTitle): originalTitle])
        }
        
        if let releaseDate = releaseDate {
            info.append([.localized(MovieString.ReleaseDate): releaseDate])
        }
        
        if let status = status {
            info.append([.localized(MovieString.Status): status])
        }
        
        if let coutries = productionCountries {
            info.append([.localized(MovieString.Country): coutries])
        }
        
        if let originalLanguage = originalLanguage {
            info.append([.localized(MovieString.OriginalLanguage): originalLanguage])
        }

        if let budget = budget {
            info.append([.localized(MovieString.Budget): budget])
        }
        
        if let revenue = revenue {
            info.append([.localized(MovieString.Revenue): revenue])
        }
        
        infoArray = info
    }
    
    private func updateTopCast() {
        guard let cast = movie.cast else { return }
        
        topCast = cast
            .prefix(8)
            .compactMap { CastCreditViewModel(castCredit: $0) }
    }
    
    private func updateTopCrew() {
        guard let crew = movie.crew else { return }

        topCrew = CrewCreditViewModel.crewWithTopJobs(credits: crew)
    }
    
    private func updateVideos() {
        guard let videos = movie.videos, videos.count > 1 else { return }
        
        self.videos = videos.map(MovieVideoViewModel.init)
    }
    
}
