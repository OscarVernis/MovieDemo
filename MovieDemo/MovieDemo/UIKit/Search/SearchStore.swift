//
//  SearchStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

enum SearchResultViewModel: Hashable {
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
    
    var searchProvider: PaginatedProvider<SearchResultViewModel>!
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
                searchProvider.refresh()
            }
        
        searchProvider = PaginatedProvider(service: providerService)
    }
    
    private lazy var providerService = { [unowned self] (page: Int) in
        if query.isEmpty {
            return Just([SearchResultViewModel]())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return searchService(query, page)
                .map { $0.map(SearchResultViewModel.init) }
                .eraseToAnyPublisher()
        }
    }
    
}
