//
//  RemoteUserService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteUserService {
   static func getUserDetails(sessionId: String?) -> AnyPublisher<User, Error> {
        let params = ["append_to_response": "favorite/movies,rated/movies,watchlist/movies"]
        let service = MovieService(sessionId: sessionId)

        return service.getModel(endpoint: .userDetails, parameters: params)
    }

}
