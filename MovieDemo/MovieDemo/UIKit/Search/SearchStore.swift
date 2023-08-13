//
//  SearchStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

enum SearchProviderResultItem: Hashable {
    case person(PersonViewModel)
    case movie(MovieViewModel)
    
    init(searchResultItem: SearchResultItem) {
        switch searchResultItem {
        case .person(let person):
            self = .person(PersonViewModel(person: person))
        case .movie(let movie):
            self = .movie(MovieViewModel(movie: movie))
        }
    }
}

class SearchStore {
    @Published var query: String = ""
    
    var searchProvider: PaginatedProvider<SearchProviderResultItem>!
    var searchService: SearchService
    var queryCancellable: AnyCancellable?
    
    init(searchService: @escaping SearchService) {
        self.searchService = searchService
        setup()
    }
    
    private func setup() {
        queryCancellable = $query
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [unowned self] _ in
                refresh()
            }
        
        searchProvider = PaginatedProvider(service: providerService)
    }
    
    private lazy var providerService = { [unowned self] (page: Int) in
        if query.isEmpty {
            return Just([SearchProviderResultItem]())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return searchService(query, page)
                .map(\.items)
                .map { $0.map(SearchProviderResultItem.init) }
                .eraseToAnyPublisher()
        }
    }
    
    private func refresh() {
        searchProvider.refresh()
    }
    
}
