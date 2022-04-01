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

    @Published var query: String = ""
    
    override init() {
        super.init()
        
        $query
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap { query -> String? in
                if query.count < 1 {
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
    
    override func getItems() {
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
                self?.totalPages = totalPages
                self?.items.append(contentsOf: items)
            }
            .store(in: &cancellables)
    }
    
}
