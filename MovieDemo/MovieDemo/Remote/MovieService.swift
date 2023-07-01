//
//  MovieService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

//MARK: - MovieService
struct MovieService {
    enum ServiceError: Error, Equatable {
        case RequestError
        case StatusCodeError(code: Int)
        case JsonError
        case IncorrectCredentials
        case NoSuccess
    }
    
    let sessionId: String?
    
    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        return URLSession(configuration: configuration)
    }()
        
    init(sessionId: String? = nil, session: URLSession? = nil) {
        self.sessionId = sessionId
        
        if let session = session {
            self.session = session
        }
    }

}

//MARK: - Generic Functions
extension MovieService {
    func getModel<Model: Codable>(endpoint: Endpoint, parameters: [String: String]? = nil) -> AnyPublisher<Model, Error> {
        let url = endpoint.url(parameters: parameters, sessionId: self.sessionId)
        
        return session
            .dataTaskPublisher(for: url)
            .validate()
            .decode(type: Model.self, decoder: jsonDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getModels<Model: Codable>(endpoint: Endpoint, parameters: [String: String] = [:], page: Int = 1) -> AnyPublisher<ServiceModelsResult<Model>, Error> {
        var params = parameters
        params["page"] = String(page)
        
        return getModel(endpoint: endpoint, parameters: params)
    }
    
    func successAction(endpoint: Endpoint, body: (any Encodable)? = nil, method: HTTPMethod = .get) -> AnyPublisher<ServiceSuccessResult, Error>  {
        let url = endpoint.url(sessionId: self.sessionId)
        let request = request(for: url, method: method, payload: body)

        return session
            .dataTaskPublisher(for: request)
            .validate()
            .decode(type: ServiceSuccessResult.self, decoder: jsonDecoder(keyDecodingStrategy: .convertFromSnakeCase))
            .tryMap { result in
                guard let success = result.success, success == true else { throw ServiceError.NoSuccess }

                return result
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

//MARK: - Helpers
extension MovieService {
    private func jsonDecoder(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        MovieDecoder(dateFormat: dateFormat, keyDecodingStrategy: keyDecodingStrategy)
    }
    
    private func request(for url: URL, method: HTTPMethod, payload: (any Encodable)? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let payload = payload {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let codedBody: Data? = try? JSONEncoder().encode(payload)
            request.httpBody = codedBody
        }
        
        return request
    }
}
