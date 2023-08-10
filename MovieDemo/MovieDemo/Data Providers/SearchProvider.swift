//
//  SearchProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

enum SearchProviderResultItem: Hashable {
    case person(PersonViewModel)
    case movie(MovieViewModel)
}

class SearchProvider: PaginatedProvider<SearchProviderResultItem> {
    typealias Model = Any

    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                items.removeAll()
                didUpdate?(nil)
            }
        }
    }
    
    let searchService: SearchService
    var queryCancellable: AnyCancellable?

    init(searchService: @escaping SearchService) {
        self.searchService = searchService
        super.init()
        
        queryCancellable = $query
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
    }
    
    override func getItems() {
        guard !query.isEmpty else { return }
        
        Task { await itemsTask() }
    }
    
    @MainActor func itemsTask() async {
        let page = currentPage + 1
        
        let result: SearchResult
        do {
            result = try await searchService(query, page).async()
        } catch {
            didUpdate?(error)
            return
        }
        
        if currentPage == 0 {
            items.removeAll()
        }
            
        let itemViewModels: [SearchProviderResultItem] = result.items.compactMap { item in
            switch item {
            case .movie(let movie):
                return .movie(MovieViewModel(movie: movie))
            case .person(let person):
                return .person(PersonViewModel(person: person))
            }
        }
        
        currentPage += 1
        items.append(contentsOf: itemViewModels)
        totalPages = result.totalPages

        didUpdate?(nil)
    }

}
