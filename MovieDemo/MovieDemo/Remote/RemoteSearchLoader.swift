//
//  RemoteSearchLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteSearchLoader: SearchLoader {
    let service: TMDBClient
    
    init(service: TMDBClient = TMDBClient()) {
        self.service = service
    }
    
    func search(query: String, page: Int = 1) -> AnyPublisher<SearchResult, Error>  {
        let publisher: AnyPublisher<ServiceModelsResult<MediaItem>, Error> = service.getModels(endpoint: .search, parameters: ["query" : query], page: page)
        
        return publisher
            .compactMap { result in
                let searchResults: [Any] = result.items.compactMap { item -> Any? in
                    switch item {
                    case .person(let person):
                        return person
                    case .movie(let movie):
                        return movie
                    case .unknown:
                        return nil
                    }
                }
                
                return (searchResults, result.totalPages)
            }
            .eraseToAnyPublisher()
    }
    
}
