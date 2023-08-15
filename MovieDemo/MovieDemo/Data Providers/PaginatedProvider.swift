//
//  PaginatedProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class PaginatedProvider<Model>: DataProvider, ObservableObject {
    let service: (Int) -> AnyPublisher<[Model], Error>
    var serviceCancellable: AnyCancellable?
    
    @Published var items = [Model]()
    var itemsPublished: Published<[Model]> { _items }
    var itemsPublisher: Published<[Model]>.Publisher { $items }
    
    @Published var error: Error?
    var errorPublished: Published<Error?> { _error }
    var errorPublisher: Published<Error?>.Publisher { $error }
        
    init(service: @escaping (Int) -> AnyPublisher<[Model], Error>) {
        self.service = service
    }
    
    var currentPage = 0
    
    var isLastPage: Bool = true
    
    func refresh() {
        error = nil
        if !items.isEmpty {
            items = []
        }
        isLastPage = false
        currentPage = 0
        getItems()
    }
    
    func loadMore() {
        if !isLastPage {
            getItems()
        }
    }
    
    private func getItems() {
        let page = currentPage + 1
        
        serviceCancellable = service(page)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    if !isLastPage {
                        self.currentPage += 1
                    }
                case .failure(let error):
                    isLastPage = true
                    self.error = error
                }
            } receiveValue: { [weak self] resultModels in
                guard let self = self else { return }
                
                if resultModels.isEmpty {
                    isLastPage = true
                }
                          
                var newItems: [Model]
                if self.currentPage == 0 {
                    newItems = []
                } else {
                    newItems = items
                }
                
                newItems.append(contentsOf: resultModels)
                self.items = newItems
            }
    }
    
}
