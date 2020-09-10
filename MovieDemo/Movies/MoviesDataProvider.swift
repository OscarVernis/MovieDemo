//
//  MoviesDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

enum MovieService: Int {
    case NowPlaying = 0
    case Popular
    case TopRated
    case Upcoming
    case Searching
}

class MoviesDataProvider {
    var movies = [Movie]()
    
    var movieService: MovieService = .NowPlaying {
        didSet {
           movieServiceChanged()
        }
    }
    
    var searchQuery = "" {
        didSet {
            refresh()
        }
    }
    
    var isFetching = false
    var currentPage = 1
    var totalPages = 1
    
    var completionHandler: (() -> Void)?
    
    func movieServiceChanged() {
        if movieService != .Searching {
            searchQuery = ""
        }
        
        refresh()
    }
    
    func fetchNextPage() {
        if(currentPage >= totalPages) {
            return
        }
        
        currentPage += 1
        fetchMovies()
    }
    
    func refresh() {
        currentPage = 1
        totalPages = 1
        fetchMovies()
    }
    
    func fetchMovies() {
        if isFetching {
            return
        }
        
        isFetching = true
        
        let fetchHandler: ([Movie], Int, Error?) -> () = { [weak self] movies, totalPages, error in
            guard let self = self else { return }
            
            self.isFetching = false
            
            if let error = error {
                print(error)
                return
            }
            
            if self.currentPage == 1 {
                self.movies.removeAll()
            }
            
            self.totalPages = totalPages
            self.currentPage += 1
            
            self.movies.append(contentsOf: movies)
            
            self.completionHandler?()
        }
        
        switch movieService {
        case .NowPlaying:
            Movie.fetchNowPlaying(page: currentPage, completion: fetchHandler)
        case .Popular:
            Movie.fetchPopular(page: currentPage, completion: fetchHandler)
        case .TopRated:
            Movie.fetchTopRated(page: currentPage, completion: fetchHandler)
        case .Upcoming:
            Movie.fetchUpcoming(page: currentPage, completion: fetchHandler)
        case .Searching:
            Movie.search(query: searchQuery, page: currentPage, completion: fetchHandler)
        }
    }
    
}
