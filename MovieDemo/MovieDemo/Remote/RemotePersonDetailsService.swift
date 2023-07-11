//
//  RemotePersonDetailsService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemotePersonDetailsService {
    static let service = MovieService()
    
    static func getPersonDetails(personId: Int) -> AnyPublisher<Person, Error> {
        let params = ["append_to_response": "movie_credits"]
        
        return service.getModel(endpoint: .personDetails(personId: personId), parameters: params)
    }
    
}
