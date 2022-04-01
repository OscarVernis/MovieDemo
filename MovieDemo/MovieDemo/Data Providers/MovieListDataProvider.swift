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
    
    var currentPage = 0
    var totalPages = 1
    
    var isLastPage: Bool {
        currentPage == totalPages || currentPage == 0
    }
    
    var didUpdate: ((Error?) -> Void)?
    
    func loadMore() {
        if !isLastPage {
            getMovies()
        }
        
    }
    
    func refresh() {
        movies.removeAll()
        currentPage = 0
        totalPages = 1
        getMovies()
    }
    
    private func getMovies() {
        let page = currentPage + 1
        
        movieLoader.getMovies(movieList: currentService, page: page)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.currentPage += 1
                    self?.didUpdate?(nil)
                case .failure(let error):
                    self?.didUpdate?(error)
                }
            } receiveValue: { [weak self] movies, totalPages in
                self?.totalPages = totalPages
                self?.movies.append(contentsOf: movies)
            }
            .store(in: &cancellables)
    }
    
}
