//
//  ItemProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class ItemProvider<T>: DataProvider, ObservableObject {
    typealias Model = T
    
    let service: (Int) -> AnyPublisher<[Model], Error>
    let cache: (any ModelCache<[Model]>)?
    var serviceCancellable: AnyCancellable?
    
    var items = [T]()
    var itemsPublisher: AnyPublisher<[Model], Error> {
        passthroughSubject.eraseToAnyPublisher()
    }
    
    private var passthroughSubject = PassthroughSubject<[Model], Error>()
    
    init(service: @escaping (Int) -> AnyPublisher<[Model], Error>, cache: (any ModelCache<[Model]>)? = nil) {
        self.service = service
        self.cache = cache
    }
    
    var currentPage = 0
    var totalPages = 1
    
    var isLastPage: Bool = true
    
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
    
    fileprivate func loadFromCache() {
        //Only load from Cache on first page and when items are empty.
        guard let cache = cache,
              currentPage == 0,
              items.count == 0
        else { return }
        
        let cacheItems = try? cache.load()
        
        if let cacheItems {
            items = cacheItems
        }
    }
    
    func getItems() {
        let page = currentPage + 1
        loadFromCache()
        
        serviceCancellable = service(page)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.currentPage += 1
                    self.didUpdate?(nil)
                    passthroughSubject.send(items)
                case .failure(let error):
                    self.didUpdate?(error)
                    passthroughSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] resultModels in
                guard let self = self else { return }
                
                if resultModels.isEmpty {
                    isLastPage = true
                    return
                }
                
                var models: [Model]
                if self.currentPage == 0 {
                    models = []
                    self.cache?.delete()
                } else {
                    models = items
                }
                
                self.cache?.save(resultModels)
                models.append(contentsOf: resultModels)
                self.items = models
            }
    }
    
}
