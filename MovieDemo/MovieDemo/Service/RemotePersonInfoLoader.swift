//
//  RemotePersonInfoLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct RemotePersonInfoLoader {
    let service = MovieDBService()
    
    func fetchPersonDetails(personId: Int, completion: @escaping ((Result<Person, Error>)) -> ()) {
        let url = service.endpoint(forPath: "/person/\(personId)")
        
        var params = service.defaultParameters()
        params["append_to_response"] = "movie_credits"
        
        service.fetchModel(url: url, params: params, completion: completion)
    }
}
