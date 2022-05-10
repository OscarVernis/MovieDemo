//
//  SearchDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

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
    
    let searchService: SearchLoader
    var searchCancellable: AnyCancellable?
    var cancellables = Set<AnyCancellable>()

    init(searchLoader: SearchLoader = RemoteSearchLoader()) {
        self.searchService = searchLoader
        super.init()
        
        $query
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
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
    
    override func getItems() {
        guard !query.isEmpty else { return }
        
        let page = currentPage + 1
        
        searchCancellable = searchService.search(query: query, page: page)
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
                let itemViewModels: [Any] = items.compactMap { item in
                    switch item {
                    case let movie as Movie:
                       return MovieViewModel(movie: movie)
                    case let person as Person:
                        return PersonViewModel(person: person)
                    default:
                        return nil
                    }
                }
                
                self?.items.append(contentsOf: itemViewModels)
            }
    }

}
