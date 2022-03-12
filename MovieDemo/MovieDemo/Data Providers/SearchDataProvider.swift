//
//  SearchDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class SearchDataProvider: ArrayDataProvider {
    typealias Model = MediaItem

    var query: String = "" {
        didSet {
            refresh()
        }
    }
    
    private var items =  [MediaItem]()
    
    var itemCount: Int {
        return items.count
    }
    
    func item(atIndex index: Int) -> MediaItem {
        let item = items[index]
        
        return item
    }
    
    let searchService = RemoteSearch()

    private var isFetching = false

    var currentPage = 0
    var totalPages = 1
    
    var isLastPage: Bool {
        currentPage == totalPages || currentPage == 0
    }
    var didUpdate: ((Error?) -> Void)?
    
    func fetchNextPage() {
        if isLastPage {
            return
        }
        
        fetchItems()
    }
    
    func refresh() {
        currentPage = 0
        totalPages = 1
        fetchItems()
    }
    
    private func fetchItems() {
        if isFetching || query.isEmpty {
            return
        }
        
        isFetching = true
        let page = currentPage + 1

        let searchQuery = query
        searchService.search(query: searchQuery, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.isFetching = false
            
            switch result {
            case .success((let items, let totalPages)):
                self.currentPage += 1
                
                if self.currentPage == 1 {
                    self.items.removeAll()
                }
                
                self.totalPages = totalPages
                
                let filteredItems = items.filter { $0 != .unknown }
                self.items.append(contentsOf: filteredItems)
                
                self.didUpdate?(nil)
                
                if self.query != searchQuery {
                    self.refresh()
                }
            case .failure(let error):
                self.didUpdate?(error)
            }
        }
        
    }
    
    
}
