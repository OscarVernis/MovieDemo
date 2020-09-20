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
    var currentPage = 1
    var totalPages = 1
    
    var isLastPage: Bool {
        currentPage == totalPages
    }
    
    var didUpdate: (() -> Void)?
    
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
            
            self.didUpdate?()
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
        case .Search(let query):
            movieService.search(query: query, page: currentPage, completion: fetchHandler)
        }
        
    }
    
}
