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
    let cache: (any ModelCache<[Movie]>)?
    var serviceCancellable: AnyCancellable?
    
    init(service: @escaping MoviesService, cache: (any ModelCache<[Movie]>)? = nil) {
        self.service = service
        self.cache = cache
    }
    
    fileprivate func loadFromCache() {
        //Only load from Cache on first page and when items are empty.
        guard let cache = cache,
              currentPage == 0,
              items.count == 0
        else { return }
        
        let cacheItems = try? cache.load().map(MovieViewModel.init)
        
        if let cacheItems {
            items = cacheItems
        }
    }
    
    override func getItems() {
        let page = currentPage + 1
        loadFromCache()
        
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
                
                var movies: [MovieViewModel]
                if self.currentPage == 0 {
                    movies = []
                    self.cache?.delete()
                } else {
                    movies = items
                }
                
                self.totalPages = result.totalPages
                self.cache?.save(result.movies)
                movies.append(contentsOf: result.movies.map(MovieViewModel.init))
                self.items = movies
            }
    }
    
}
