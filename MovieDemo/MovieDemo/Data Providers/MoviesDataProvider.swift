//
//  MoviesDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

class MoviesDataProvider: PaginatedDataProvider<MovieViewModel> {
    let movieLoader: MovieLoader
    
    var currentService: MovieList = .NowPlaying {
        didSet {
           refresh()
        }
    }

    init(_ service: MovieList = .NowPlaying, movieLoader: MovieLoader = RemoteMoviesLoaderWithCache()) {
        self.currentService = service
        self.movieLoader = movieLoader
    }
    
    override func getItems() {
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
                if self?.currentPage == 0 {
                    self?.items.removeAll()
                }
                
                self?.totalPages = totalPages
                self?.items.append(contentsOf: movies.map(MovieViewModel.init) )
            }
            .store(in: &cancellables)
    }
}
