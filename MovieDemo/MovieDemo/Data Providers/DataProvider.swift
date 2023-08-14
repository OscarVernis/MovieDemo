//
//  DataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

protocol DataProvider<Model> {
    associatedtype Model
    
    var items: [Model] { get }
    var itemsPublished: Published<[Model]> { get }
    var itemsPublisher: Published<[Model]>.Publisher { get }
    
    var error: Error? { get }
    var errorPublished: Published<Error?> { get }
    var errorPublisher: Published<Error?>.Publisher { get }
        
    var isLastPage: Bool { get }
    
    var itemCount: Int { get }
    func item(atIndex: Int) -> Model

    func refresh()
    func loadMore()
}

extension DataProvider {
    var itemCount: Int {
        return items.count
    }
    
    func item(atIndex index: Int) -> Model {
        return items[index]
    }
}
