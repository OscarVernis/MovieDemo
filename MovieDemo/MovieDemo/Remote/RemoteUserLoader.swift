//
//  RemoteUserLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteUserLoader {
    let sessionId: String?
    let service: MovieService
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
        self.service = MovieService(sessionId: sessionId)
    }
}

//MARK: - Actions
extension RemoteUserLoader {
    func getUserDetails() -> AnyPublisher<User, Error> {
        let params = ["append_to_response": "favorite/movies,rated/movies,watchlist/movies"]
        
        return service.getModel(endpoint: UserEndpoint.UserDetails, parameters: params)
    }

}
