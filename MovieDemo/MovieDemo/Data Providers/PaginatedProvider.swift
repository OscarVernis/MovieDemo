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
    
    var items = [Model]()
    var itemsPublisher: AnyPublisher<[Model], Error> {
        passthroughSubject.eraseToAnyPublisher()
    }
    
    private var passthroughSubject = PassthroughSubject<[Model], Error>()
    
    init(service: @escaping (Int) -> AnyPublisher<[Model], Error>) {
        self.service = service
    }
    
    var currentPage = 0
    
    var isLastPage: Bool = true
    
    func loadMore() {
        if !isLastPage {
            getItems()
        }
    }
    
    func refresh() {
        isLastPage = false
        currentPage = 0
        getItems()
    }
    
    func getItems() {
        let page = currentPage + 1
        
        serviceCancellable = service(page)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.currentPage += 1
                    passthroughSubject.send(items)
                case .failure(let error):
                    passthroughSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] resultModels in
                guard let self = self else { return }
                
                if resultModels.isEmpty {
                    isLastPage = true
                    self.items = []
                    return
                }
                
                var models: [Model]
                if self.currentPage == 0 {
                    models = []
                } else {
                    models = items
                }
                
                models.append(contentsOf: resultModels)
                self.items = models
            }
    }
    
}
