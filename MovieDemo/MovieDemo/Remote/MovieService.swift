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
    
    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        return URLSession(configuration: configuration)
    }()
    
    let sessionId: String?
    
    init(sessionId: String? = nil, session: URLSession? = nil) {
        self.sessionId = sessionId
        
        if let session = session {
            self.session = session
        }
    }
    
    func jsonDecoder(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        MovieDecoder(dateFormat: dateFormat, keyDecodingStrategy: keyDecodingStrategy)
    }
}

//MARK: - Generic Functions
extension MovieService {
    func getModel<Model: Codable>(model: Model.Type? = nil, endpoint: Endpoint, parameters: [String: String]? = nil) -> AnyPublisher<Model, Error> {
        let url = endpoint.url(parameters: parameters, sessionId: self.sessionId)
        
        return session
            .dataTaskPublisher(for: url)
            .validate()
            .decode(type: Model.self, decoder: jsonDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getModels<Model: Codable>(model: Model.Type? = nil, endpoint: Endpoint, parameters: [String: String] = [:], page: Int = 1) -> AnyPublisher<ServiceModelsResult<Model>, Error> {
        var params = parameters
        params["page"] = String(page)
        
        return getModel(model: ServiceModelsResult<Model>.self, endpoint: endpoint, parameters: params)
    }
    
    func successAction(endpoint: Endpoint, body: (any Encodable)? = nil, method: HTTPMethod = .get) -> AnyPublisher<ServiceSuccessResult, Error>  {
        let url = endpoint.url(sessionId: self.sessionId)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let codedBody: Data? = try? JSONEncoder().encode(body)
            request.httpBody = codedBody
        }

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
//MARK: - HTTPMethods
extension MovieService {
    enum HTTPMethod: String {
        case connect = "CONNECT"
        case delete = "DELETE"
        case get = "GET"
        case head = "HEAD"
        case options = "OPTIONS"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
        case trace = "TRACE"
    }
}
