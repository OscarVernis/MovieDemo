//
//  SearchDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

class SearchDataProvider: PaginatedDataProvider<Any> {
    typealias Model = Any

    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                items.removeAll()
                didUpdate?(nil)
            }
        }
    }
    
    override init() {
        super.init()
        
        $query
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap { query -> String? in
                if query.isEmpty {
                    return nil
                }
                
                return query
            }
            .sink { [weak self] _ in
                self?.refresh()
            }
            .store(in: &cancellables)
    }
    
    let searchService = RemoteSearch()
    
    override func item(atIndex index: Int) -> Any {
        let item = items[index]
        
        switch item {
        case let movie as Movie:
           return MovieViewModel(movie: movie)
        case let person as Person:
            return PersonViewModel(person: person)
        default:
            fatalError("Unknown Media Type")
        }
    }
    
    override func getItems() {
        guard !query.isEmpty else { return }
        
        let page = currentPage + 1
        
        let searchQuery = query
        searchService.search(query: searchQuery, page: page)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.currentPage += 1
                    self?.didUpdate?(nil)
                case .failure(let error):
                    self?.didUpdate?(error)
                }
            } receiveValue: { [weak self] (items, totalPages) in
                if self?.currentPage == 0 {
                    self?.items.removeAll()
                }
                
                self?.totalPages = totalPages
                self?.items.append(contentsOf: items)
            }
            .store(in: &cancellables)
    }
    
}
