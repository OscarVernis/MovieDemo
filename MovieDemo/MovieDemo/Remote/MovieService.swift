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
    
    let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    let baseURL = "api.themoviedb.org"
    
    private let session: URLSession
    let sessionId: String?
    
    init(sessionId: String? = nil, session: URLSession? = nil) {
        self.sessionId = sessionId
        
        if let session = session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            configuration.timeoutIntervalForRequest = 5
            configuration.timeoutIntervalForResource = 5
            self.session =  URLSession(configuration: configuration)
        }
    }
}

//MARK: - Helpers
extension MovieService {
    func defaultParameters(with additionalParameters: [String: String]? = nil) -> [String: String] {
        let language = String.localized(ServiceString.ServiceLocale)
        var params: [String: String] = ["language": language, "api_key": apiKey]
        
        if let sessionId = self.sessionId {
            params["session_id"] = sessionId
        }
        
        if let additionalParameters = additionalParameters {
            params.merge(additionalParameters) { _, new in new }
        }
        
        return params
    }
    
    func urlforEndpoint(_ endpoint: Endpoint, parameters: [String: String]? = nil) -> URL {
        let path = endpoint.path
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = "/3" + path
        
        let params = defaultParameters(with: parameters)
        components.queryItems = params.compactMap{ URLQueryItem(name: $0.0, value: $0.1) }
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
    
    func jsonDecoder(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
}

//MARK: - Generic Functions
extension MovieService {
    func getModel<Model: Codable>(model: Model.Type? = nil, endpoint: Endpoint, parameters: [String: String]? = nil) -> AnyPublisher<Model, Error> {
        let url = urlforEndpoint(endpoint, parameters: parameters)
        
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
    
    func successAction<T: Encodable>(endpoint: Endpoint, body: T?, method: HTTPMethod = .get) -> AnyPublisher<ServiceSuccessResult, Error>  {
        let url = urlforEndpoint(endpoint)
        
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
    
    func successAction(endpoint: Endpoint, method: HTTPMethod = .get) -> AnyPublisher<ServiceSuccessResult, Error> {
        return successAction(endpoint: endpoint, body: Optional<String>.none, method: method)
    }
    
}

//MARK: - Image Utils
extension MovieService {
    enum MoviePosterSize: String {
        case w92, w154, w185, w342, w500, w780, original
    }
    
    enum BackdropSize: String {
        case w300, w780, w1280, original
    }
    
    enum ProfileSize: String {
        case w45, w185, h632, original
    }
    
    static let baseImageURL = "https://image.tmdb.org/t/p/"
    static let avatarImageURL = "https://www.gravatar.com/avatar/%@/?s=400"
    
    static func backdropImageURL(forPath path: String, size: BackdropSize = .original) -> URL {
        var url = URL(string: baseImageURL)!
        url.appendPathComponent(size.rawValue)
        
        return url.appendingPathComponent(path)
    }
    
    static func posterImageURL(forPath path: String, size: MoviePosterSize = .original) -> URL {
        var url = URL(string: baseImageURL)!
        url.appendPathComponent(size.rawValue)
        
        return url.appendingPathComponent(path)
    }
    
    static func profileImageURL(forPath path: String, size: ProfileSize = .original) -> URL {
        var url = URL(string: baseImageURL)!
        url.appendPathComponent(size.rawValue)
        
        return url.appendingPathComponent(path)
    }
    
    static func userImageURL(forHash hash: String) -> URL {
        let urlString = String(format: avatarImageURL, hash)
        let url = URL(string: urlString)!
                
        return url
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
