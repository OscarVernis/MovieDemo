//
//  RecommendedMoviesDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class RecommendedMoviesDataProvider: ArrayDataProvider {
    typealias Model = Movie
    
    let movieService = MovieDBService()

    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    var models = [Movie]()
    var movies: [Movie] {
        models
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
            self.currentPage += 1
            
            self.models.append(contentsOf: movies)
            
            self.didUpdate?()
        }
        
        movieService.fetchRecommendMovies(movieId: movieId, completion: fetchHandler)
    }
    
}
