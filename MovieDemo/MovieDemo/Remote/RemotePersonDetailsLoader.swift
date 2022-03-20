//
//  RemotePersonDetailsLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemotePersonDetailsLoader {
    let service = MovieDBService()
    
    func getPersonDetails(personId: Int) -> AnyPublisher<Person, Error> {
        let params = ["append_to_response": "movie_credits"]
        
        return service.getModel(path: "/person/\(personId)", parameters: params)
    }
    
    func getPersonDetails(personId: Int, completion: @escaping ((Result<Person, Error>)) -> ()) {
        let url = service.endpoint(forPath: "/person/\(personId)")
        
        var params = service.defaultParameters()
        params["append_to_response"] = "movie_credits"
        
        service.getModel(url: url, params: params, completion: completion)
    }
}
