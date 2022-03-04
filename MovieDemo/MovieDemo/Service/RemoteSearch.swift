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
    
    func search(query: String, page: Int = 1, completion: @escaping (Result<([MediaItem], Int), Error>) -> Void) {
        service.fetchModels(endpoint: "/search/multi", parameters: ["query" : query], page: page, completion: completion)
    }
}
