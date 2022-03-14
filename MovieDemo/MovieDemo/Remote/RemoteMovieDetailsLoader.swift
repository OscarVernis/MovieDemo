//
//  RemoteMovieInfoLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct RemoteMovieDetailsLoader {
    let service = MovieDBService()
    
    func fetchMovieDetails(movieId: Int, sessionId: String? = nil, completion: @escaping ((Result<Movie, Error>)) -> ()) {
        let url = service.endpoint(forPath: "/movie/\(movieId)")
        
        var params = service.defaultParameters(withSessionId: sessionId)
        params["append_to_response"] = "credits,recommendations,account_states,videos"
        
        service.fetchModel(url: url, params: params, completion: completion)
    }
}
