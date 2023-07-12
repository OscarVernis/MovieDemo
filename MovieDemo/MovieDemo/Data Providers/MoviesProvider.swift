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
    let service: MoviesService
    let cache: MovieCache?
    var serviceCancellable: AnyCancellable?
    
    init(service: @escaping MoviesService, cache: MovieCache? = nil) {
        self.service = service
        self.cache = cache
    }
    
    fileprivate func loadFromCache() {
        //Only load from Cache on first page and when items are empty.
        guard let cache = cache,
              currentPage == 0,
              items.count == 0
        else { return }
        
        items = cache.fetchMovies().map(MovieViewModel.init)
    }
    
    fileprivate func cachePublisher() -> AnyPublisher<MoviesResult, Error> {
        //Only load from Cache on first page and when items are empty.
        if let cache, currentPage == 0, items.count == 0 {
            return cache.publisher()
        } else {
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
    }
    
    override func getItems() {
        let page = currentPage + 1
        
//        serviceCancellable =
//        cachePublisher()
//            .merge(with: movieLoader.getMovies(page: page))
//            .onCompletion {
//                self.currentPage += 1
//                self.didUpdate?(nil)
//            }
//            .handleError { error in
//                self.didUpdate?(error)
//            }
//            .sink { [weak self] result in
//                guard let self = self else { return }
//                
//                if self.currentPage == 0 {
//                    self.items.removeAll()
//                    self.cache?.delete()
//                }
//                
//                self.totalPages = result.totalPages
//                self.cache?.save(result.movies)
//                self.items.append(contentsOf: result.movies.map(MovieViewModel.init))
//            }
        
        
        serviceCancellable = service(page)
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
                    self.cache?.delete()
                }
                
                self.totalPages = result.totalPages
                self.cache?.save(result.movies)
                self.items.append(contentsOf: result.movies.map(MovieViewModel.init))
            }
    }
    
}
