//
//  MovieListDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MovieListDataProvider: ArrayDataProvider {
    typealias Model = Movie
        
    enum Service: Equatable {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
        case Search(query: String)
        case Recommended(movieId: Int)
        case DiscoverWithCast(castId: Int)
        case DiscoverWithCrew(crewId: Int)
        case UserFavorites
        case UserWatchList
        case UserRated
    }
    
    init(_ service: Service = .NowPlaying) {
        self.currentService = service
    }
    
    let movieService = MovieDBService()
    
    var models = [Movie]()
    var movies: [Movie] {
        models
    }
    
    var currentService: Service = .NowPlaying {
        didSet {
           refresh()
        }
    }
    
    private var isFetching = false
    var currentPage = 0
    var totalPages = 1
    
    var isLastPage: Bool {
        currentPage == totalPages || currentPage == 0
    }
    
    var didUpdate: ((Error?) -> Void)?
    
    func fetchNextPage() {
        if isLastPage {
            return
        }
        
        fetchMovies()
    }
    
    func refresh() {
        currentPage = 0
        totalPages = 1
        fetchMovies()
    }
    
    private func fetchMovies() {
        if isFetching {
            return
        }
        
        isFetching = true
        
        let fetchHandler: MovieDBService.MovieListCompletion = { [weak self] result in
            guard let self = self else { return }
            
            self.isFetching = false
            
            switch result {
            case .success((let movies, let totalPages)):
                self.currentPage += 1
                
                if self.currentPage == 1 {
                    self.models.removeAll()
                }
                
                self.totalPages = totalPages
                
                if self.currentService == .Upcoming { //If is upcoming sort by Release Date
                    self.models.append(contentsOf: movies.sorted {
                        guard let releaseDate1 = $0.releaseDate else { return false }
                        guard let releaseDate2 = $1.releaseDate else { return false }
                        
                        return releaseDate1 < releaseDate2
                    })
                } else {
                    self.models.append(contentsOf: movies)
                }
                
                self.didUpdate?(nil)
            case .failure(let error):
                self.didUpdate?(error)
            }
            
        }
        
        let page = currentPage + 1
        switch currentService {
        case .NowPlaying:
            movieService.fetchNowPlaying(page: page, completion: fetchHandler)
        case .Popular:
            movieService.fetchPopular(page: page, completion: fetchHandler)
        case .TopRated:
            movieService.fetchTopRated(page: page, completion: fetchHandler)
        case .Upcoming:
            movieService.fetchUpcoming(page: page, completion: fetchHandler)
        case .Search(query: let query):
            movieService.movieSearch(query: query, page: page, completion: fetchHandler)
        case .Recommended(movieId: let movieId):
            movieService.fetchRecommendMovies(movieId: movieId, page: page, completion: fetchHandler)
        case .DiscoverWithCast(castId: let castId):
            movieService.discover(params: [.withCast: castId], page: page, completion: fetchHandler)
        case .DiscoverWithCrew(crewId: let crewId):
            movieService.discover(params: [.withCrew: crewId], page: page, completion: fetchHandler)
        case .UserFavorites:
            if let sessionId = SessionManager.shared.sessionId {
                movieService.fetchUserFavorites(sessionId: sessionId, page: page, completion: fetchHandler)
            }
        case .UserWatchList:
            if let sessionId = SessionManager.shared.sessionId {
                movieService.fetchUserWatchlist(sessionId: sessionId, page: page, completion: fetchHandler)
            }
        case .UserRated:
            if let sessionId = SessionManager.shared.sessionId {
                movieService.fetchUserRatedMovies(sessionId: sessionId, page: page, completion: fetchHandler)
            }
        }
        
    }
    
}
