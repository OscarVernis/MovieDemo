//
//  StaticArrayDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class StaticArrayDataProvider<T>: ArrayDataProvider {
    typealias Model = T
    
    private var items: [T]
    
    init(models: [T]) {
        self.items = models
    }
    
    var itemCount: Int {
        return items.count
    }
    
    func item(atIndex index: Int) -> T {
        return items[index]
    }
    
    var currentPage = 1
    var totalPages = 1
    var isLastPage = true
    
    var didUpdate: ((Error?) -> Void)?
    
    func fetchNextPage() {}
    
    func refresh() {
        didUpdate?(nil)
    }
    
}
