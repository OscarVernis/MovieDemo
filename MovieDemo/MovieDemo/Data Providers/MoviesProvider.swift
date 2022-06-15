//
//  MoviesProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MoviesProvider: PaginatedProvider<MovieViewModel> {
    let movieLoader: MovieLoader
    let cache: MovieCache?
    var serviceCancellable: AnyCancellable?
    
    var currentService: MovieList = .NowPlaying {
        didSet {
           refresh()
        }
    }

    init(_ service: MovieList = .NowPlaying,
         movieLoader: MovieLoader = RemoteMoviesLoader(),
         cache: MovieCache? = MovieCache()) {
        self.currentService = service
        self.movieLoader = movieLoader
        self.cache = cache
    }
    
    func loadFromCache() {
        //Only load from Cache on first page and when items are empty.
        guard let cache = cache,
                currentPage == 0,
                items.count == 0
        else { return }
        
        items = cache.fetchMovies(movieList: currentService).map { MovieViewModel(movie: $0) }
    }
    
    override func getItems() {
        let page = currentPage + 1
        loadFromCache()
        
        serviceCancellable = movieLoader.getMovies(movieList: currentService, page: page)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.currentPage += 1
                    self.didUpdate?(nil)
                case .failure(let error):
                    self.didUpdate?(error)
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                if self.currentPage == 0 {
                    self.items.removeAll()
                    self.cache?.delete(movieList: self.currentService)
                }
                
                self.totalPages = result.totalPages
                self.cache?.save(movies: result.movies, movieList: self.currentService)
                self.items.append(contentsOf: result.movies.map { MovieViewModel(movie: $0) })
            }
    }
    
}
