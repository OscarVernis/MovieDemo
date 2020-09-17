//
//  DataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

protocol ArrayDataProvider {
    associatedtype Model
    
    var models: [Model] { get }
    var currentPage: Int { get }
    var totalPages: Int { get }
    var isLastPage: Bool { get }
    var didUpdate: (() -> Void)? { get set }
    
    func fetchNextPage()
    func refresh()

}
