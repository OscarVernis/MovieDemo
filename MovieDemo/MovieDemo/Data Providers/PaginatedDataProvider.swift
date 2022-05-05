//
//  PaginatedDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class PaginatedDataProvider<T>: ArrayDataProvider {
    typealias Model = T
    
    var items = [T]()
    var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    var itemCount: Int {
        return items.count
    }
    
    func item(atIndex index: Int) -> T {
        return items[index]
    }
    
    var currentPage = 0
    var totalPages = 1
    
    var isLastPage: Bool {
        currentPage == totalPages || currentPage == 0
    }
    
    var didUpdate: ((Error?) -> Void)?
    
    func loadMore() {
        if !isLastPage {
            getItems()
        }
    }
    
    func refresh() {
        currentPage = 0
        totalPages = 1
        getItems()
    }
    
     func getItems() {
        fatalError("")
    }
    
}
