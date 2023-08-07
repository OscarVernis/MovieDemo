//
//  PagingDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

protocol PagingDataSource<Model> {
    associatedtype Model
    
    var didUpdate: ((Error?) -> ())? { get set }
    var isLoading: Bool { get }
    var isRefreshable: Bool { get }
    
    func refresh()
    func loadMore()
    func model(at: IndexPath) -> Model?
}
