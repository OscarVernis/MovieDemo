//
//  StaticArrayDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct StaticArrayDataProvider<T>: ArrayDataProvider {
    typealias Model = T
    
    private(set) var items: [T]
    
    init(models: [T]) {
        self.items = models
    }
    
    var isLastPage = true
    
    var didUpdate: ((Error?) -> Void)?
    
    func loadMore() {}
    
    func refresh() {
        didUpdate?(nil)
    }
    
}
