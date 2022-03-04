//
//  MovieListDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MovieListDataProvider: ArrayDataProvider {
    typealias Model = MovieViewModel
    
    init(_ service: MovieList = .NowPlaying, movieLoader: MovieLoader = RemoteMovieLoader(sessionId: SessionManager.shared.sessionId)) {
        self.currentService = service
        self.movieLoader = movieLoader
    }
    
    let movieLoader: MovieLoader
    
    
    private var movies = [Movie]()
    
    var itemCount: Int {
        return movies.count
    }
    
    func item(atIndex index: Int) -> MovieViewModel {
        let movie = movies[index]
        
        return MovieViewModel(movie: movie)
    }
    
    var currentService: MovieList = .NowPlaying {
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
                    self.movies.removeAll()
                }
                
                self.totalPages = totalPages
                
                if self.currentService == .Upcoming { //If is upcoming sort by Release Date
                    self.movies.append(contentsOf: movies.sorted {
                        guard let releaseDate1 = $0.releaseDate else { return false }
                        guard let releaseDate2 = $1.releaseDate else { return false }
                        
                        return releaseDate1 < releaseDate2
                    })
                } else {
                    self.movies.append(contentsOf: movies)
                }
                
                self.didUpdate?(nil)
            case .failure(let error):
                self.didUpdate?(error)
            }
            
        }
        
        let page = currentPage + 1
        
        movieLoader.getMovies(movieList: currentService, page: page, completion: fetchHandler)
    }
    
}
