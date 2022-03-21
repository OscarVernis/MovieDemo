//
//  SearchDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class SearchDataProvider: ArrayDataProvider {
    typealias Model = Any

    @Published var query: String = ""
    
    private var items =  [Any]()
    
    var itemCount: Int {
        return items.count
    }
    
    init() {
        $query
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap { query -> String? in
                if query.count < 1 {
                    return nil
                }
                
                return query
            }
            .sink { _ in
                
            } receiveValue: { _ in
                self.refresh()
            }
            .store(in: &cancellables)
    }
    
    func item(atIndex index: Int) -> Any {
        let item = items[index]
        
        return item
    }
    
    let searchService = RemoteSearch()

    private var isLoading = false

    var currentPage = 0
    var totalPages = 1
    
    var isLastPage: Bool {
        currentPage == totalPages || currentPage == 0
    }
    var didUpdate: ((Error?) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadMore() {
        if isLastPage {
            return
        }
        
        getItems()
    }
    
    func refresh() {
        currentPage = 0
        totalPages = 1
        getItems()
    }
    
    private func getItems() {
        if isLoading || query.isEmpty {
            return
        }
        
        isLoading = true
        let page = currentPage + 1
        
        let searchQuery = query
        searchService.search(query: searchQuery, page: page)
            .sink { completion in
                self.isLoading = false
                
                switch completion {
                case .finished:
                    self.didUpdate?(nil)
                case .failure(let error):
                    self.didUpdate?(error)
                }
            } receiveValue: { (items, totalPages) in
                self.currentPage += 1
                
                if self.currentPage == 1 {
                    self.items.removeAll()
                }
                
                self.totalPages = totalPages
                
                self.items.append(contentsOf: items)
            }
            .store(in: &cancellables)
    }
    
}
