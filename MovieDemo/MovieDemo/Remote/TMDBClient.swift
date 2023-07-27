//
//  TMDBClient.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

//MARK: - TMDBClient
struct TMDBClient {
    enum ServiceError: Error, Equatable {
        case RequestError
        case StatusCodeError(code: Int)
        case JsonError
        case IncorrectCredentials
        case NoSuccess
    }
    
    let sessionId: String?
    let httpClient: HTTPClient
        
    init(sessionId: String? = nil, httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.sessionId = sessionId
        self.httpClient = httpClient
    }

}

//MARK: - Generic Functions
extension TMDBClient {
    func getModel<Model: Codable>(endpoint: Endpoint, parameters: [String: String]? = nil) -> AnyPublisher<Model, Error> {
        let url = endpoint.url(parameters: parameters, sessionId: sessionId)
        
        return httpClient
            .requestPublisher(with: url)
            .validate()
            .decode(type: Model.self, decoder: MovieDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getModels<Model: Codable>(endpoint: Endpoint, parameters: [String: String] = [:], page: Int = 1) -> AnyPublisher<ServiceModelsResult<Model>, Error> {
        var params = parameters
        params["page"] = String(page)
        
        return getModel(endpoint: endpoint, parameters: params)
    }
    
    func successAction(endpoint: Endpoint, body: (any Encodable)? = nil, method: HTTPMethod = .get, parameters: [String: String]? = nil) -> AnyPublisher<ServiceSuccessResult, Error>  {
        let url = endpoint.url(parameters: parameters, sessionId: sessionId)

        return httpClient
            .requestPublisher(with: url, body: body, method: method)
            .validate()
            .decode(type: ServiceSuccessResult.self, decoder: MovieDecoder(keyDecodingStrategy: .convertFromSnakeCase))
            .tryMap { result in
                guard let success = result.success, success == true else { throw ServiceError.NoSuccess }

                return result
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
