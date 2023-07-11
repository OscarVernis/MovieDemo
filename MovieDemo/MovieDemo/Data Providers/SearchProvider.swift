//
//  SearchProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class SearchProvider: PaginatedProvider<Any> {
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
    var queryCancellable: AnyCancellable?

    init(searchLoader: SearchLoader) {
        self.searchService = searchLoader
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
            result = try await searchService.search(query: query, page: page).async()
        } catch {
            didUpdate?(error)
            return
        }
        
        if currentPage == 0 {
            items.removeAll()
        }
            
        let itemViewModels: [Any] = result.items.compactMap { item in
            switch item {
            case let movie as Movie:
               return MovieViewModel(movie: movie)
            case let person as Person:
                return PersonViewModel(person: person)
            default:
                return nil
            }
        }
        
        currentPage += 1
        items.append(contentsOf: itemViewModels)
        totalPages = result.totalPages

        didUpdate?(nil)
    }

}
