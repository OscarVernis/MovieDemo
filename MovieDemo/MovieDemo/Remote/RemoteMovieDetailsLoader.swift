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
    let service: MovieService
    
    init(sessionId: String? = nil) {
        self.service = MovieService(sessionId: sessionId)
    }
    
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        let params = ["append_to_response" : "credits,recommendations,account_states,videos"]
        
        return service.getModel(endpoint: .MovieDetails(movieId: movieId), parameters: params)
    }
    
}
