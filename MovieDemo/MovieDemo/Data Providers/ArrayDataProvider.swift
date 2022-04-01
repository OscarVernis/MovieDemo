//
//  DataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

public protocol ArrayDataProvider {
    associatedtype Model
    
    var currentPage: Int { get }
    var totalPages: Int { get }
    var isLastPage: Bool { get }
    var didUpdate: ((Error?) -> Void)? { get set }
    
    var itemCount: Int { get }
    func item(atIndex: Int) -> Model

    func loadMore()
    func refresh()

}
