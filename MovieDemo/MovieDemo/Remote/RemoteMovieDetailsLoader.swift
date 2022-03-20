//
//  RemoteMovieInfoLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteMovieDetailsLoader {
    let sessionId: String?
    let service: MovieDBService
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
        self.service = MovieDBService(sessionId: sessionId)
    }
    
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        var params = service.defaultParameters()
        params["append_to_response"] = "credits,recommendations,account_states,videos"
        
        return service.getModel(path: "/movie/\(movieId)", parameters: params)
    }
    
}
