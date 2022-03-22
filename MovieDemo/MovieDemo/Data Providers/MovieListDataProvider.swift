//
//  MovieListDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MovieListDataProvider: ArrayDataProvider {
    typealias Model = MovieViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ service: MovieList = .NowPlaying, movieLoader: MovieLoader = RemoteMoviesLoaderWithCache()) {
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
    
    private var isLoading = false
    var currentPage = 0
    var totalPages = 1
    
    var isLastPage: Bool {
        currentPage == totalPages || currentPage == 0
    }
    
    var didUpdate: ((Error?) -> Void)?
    
    func loadMore() {
        if isLastPage {
            return
        }
        
        getMovies()
    }
    
    func refresh() {
        currentPage = 0
        totalPages = 1
        getMovies()
    }
    
    private func getMovies() {
        if isLoading {
            return
        }
        
        isLoading = true
        
        let completionHandler: MovieLoader.MovieListCompletion = { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success((let movies, let totalPages)):
                self.currentPage += 1
                
                if self.currentPage == 1 {
                    self.movies.removeAll()
                }
                
                self.totalPages = totalPages
                self.movies.append(contentsOf: movies)

                self.didUpdate?(nil)
            case .failure(let error):
                self.didUpdate?(error)
            }
            
        }
        
        let page = currentPage + 1
        
        movieLoader.getMovies(movieList: currentService, page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            } receiveValue: { movies, totalPages in
                completionHandler(.success((movies, totalPages)))
            }
            .store(in: &cancellables)
    }
    
}
