//
//  File.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct RemoteSearch {
    let service = MovieDBService()
    
    func search(query: String, page: Int = 1, completion: @escaping (Result<([Any], Int), Error>) -> Void) {
        service.getModels(endpoint: "/search/multi", parameters: ["query" : query], page: page) { (result: Result<([MediaItem], Int), Error>) in
            switch result {
            case .success((let serviceResults, let totalPages)):
                let results: [Any] = serviceResults.compactMap { Item in
                    switch Item {
                    case .person(let person):
                        return person
                    case .movie(let movie):
                        return movie
                    case .unknown:
                        return nil
                    }
                }
                
                completion(.success((results, totalPages)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
