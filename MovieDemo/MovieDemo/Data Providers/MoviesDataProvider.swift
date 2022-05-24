//
//  MoviesDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MoviesDataProvider: PaginatedDataProvider<MovieViewModel> {
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
    
    override func getItems() {
        let page = currentPage + 1
        
        serviceCancellable = movieLoader.getMovies(movieList: currentService, page: page)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.currentPage += 1
                    self.didUpdate?(nil)
                case .failure(let error):
                    let movies = self.cache?.fetchMovies(movieList: self.currentService) ?? [Movie]()
                    self.items = movies.map { MovieViewModel(movie: $0) }
                    
                    if page == 0 && movies.count > 0 {
                        self.didUpdate?(nil)
                    } else {
                        self.didUpdate?(error)
                    }
                }
            } receiveValue: { [weak self] movies, totalPages in
                guard let self = self else { return }
                
                if self.currentPage == 0 {
                    self.items.removeAll()
                    self.cache?.delete(movieList: self.currentService)
                }
                
                self.totalPages = totalPages
                self.cache?.save(movies: movies, movieList: self.currentService)
                self.items.append(contentsOf: movies.map { MovieViewModel(movie: $0) })
            }
    }
    
}
