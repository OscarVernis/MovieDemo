//
//  RemoteMovieDetailsService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteMovieDetailsService {
    static func getMovieDetails(movieId: Int, sessionId: String?) -> AnyPublisher<Movie, Error> {
        let params = ["append_to_response" : "credits,recommendations,account_states,videos"]
        let service = MovieService(sessionId: sessionId)
        
        return service.getModel(endpoint: .movieDetails(movieId: movieId), parameters: params)
    }
    
}
