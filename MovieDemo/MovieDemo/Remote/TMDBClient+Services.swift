//
//  TMDBClient+Services.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

//MARK: - Details
extension TMDBClient {
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        let params = ["append_to_response" : "credits,recommendations,account_states,videos"]
        
        return getModel(endpoint: .movieDetails(movieId: movieId), parameters: params)
    }
    
    func getPersonDetails(personId: Int) -> AnyPublisher<Person, Error> {
        let params = ["append_to_response": "movie_credits"]
        
        return getModel(endpoint: .personDetails(personId: personId), parameters: params)
    }
    
    func getUserDetails() -> AnyPublisher<User, Error> {
         let params = ["append_to_response": "favorite/movies,rated/movies,watchlist/movies"]

         return getModel(endpoint: .userDetails, parameters: params)
     }
    
}

//MARK: - Search
extension TMDBClient: SearchLoader {
    func search(query: String, page: Int = 1) -> AnyPublisher<SearchResult, Error>  {
        let publisher: AnyPublisher<ServiceModelsResult<MediaItem>, Error> = getModels(endpoint: .search, parameters: ["query" : query], page: page)
        
        return publisher
            .compactMap { result in
                let searchResults: [Any] = result.items.compactMap { item -> Any? in
                    switch item {
                    case .person(let person):
                        return person
                    case .movie(let movie):
                        return movie
                    case .unknown:
                        return nil
                    }
                }
                
                return (searchResults, result.totalPages)
            }
            .eraseToAnyPublisher()
    }
    
}
