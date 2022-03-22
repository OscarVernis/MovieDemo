//
//  File.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteSearch {
    let service = MovieService()
    
    func search(query: String, page: Int = 1) -> AnyPublisher<([Any], Int), Error>  {
        let publisher: AnyPublisher<([MediaItem], Int), Error> = service.getModels(endpoint: .Search, parameters: ["query" : query], page: page)
        
        return publisher
            .compactMap { (items, totalPages) in
                let searchResults: [Any] = items.compactMap { item in
                    switch item {
                    case .person(let person):
                        return person
                    case .movie(let movie):
                        return movie
                    case .unknown:
                        return nil
                    }
                }
                
                return (searchResults, totalPages)
            }
            .eraseToAnyPublisher()
    }
    
}
