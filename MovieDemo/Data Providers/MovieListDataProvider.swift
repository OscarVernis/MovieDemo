//
//  MovieListDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MovieListDataProvider {
    enum Service: Int {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
        case Search
    }
    
    init(_ service: Service = .NowPlaying) {
        self.currentService = service
    }
    
    let movieService = MovieDBService()
    
    var movies = [Movie]()
    
    var currentService: Service = .NowPlaying {
        didSet {
           movieServiceChanged()
        }
    }
    
    var searchQuery = "" {
        didSet {
            refresh()
        }
    }
    
    private var isFetching = false
    var currentPage = 1
    var totalPages = 1
    
    var completionHandler: (() -> Void)?
    
    func movieServiceChanged() {
        if currentService != .Search {
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
        if currentService == .Search, searchQuery.isEmpty {
            return
        }
        
        currentPage = 1
        totalPages = 1
        fetchMovies()
    }
    
    private func fetchMovies() {
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
        
        switch currentService {
        case .NowPlaying:
            movieService.fetchNowPlaying(page: currentPage, completion: fetchHandler)
        case .Popular:
            movieService.fetchPopular(page: currentPage, completion: fetchHandler)
        case .TopRated:
            movieService.fetchTopRated(page: currentPage, completion: fetchHandler)
        case .Upcoming:
            movieService.fetchUpcoming(page: currentPage, completion: fetchHandler)
        case .Search:
            movieService.search(query: searchQuery, page: currentPage, completion: fetchHandler)
        }
    }
    
}
