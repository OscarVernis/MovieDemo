//
//  MovieService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import Alamofire
import Combine

struct MovieService {
    enum ServiceError: Error {
        case jsonError
        case incorrectCredentials
        case noSuccess
    }
    
    let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    let baseURL = "api.themoviedb.org"
    
    private let sessionManager: Session
    let sessionId: String?
    
    init(sessionId: String? = nil, session: Session? = nil) {
        self.sessionId = sessionId
        
        if let session = session {
            self.sessionManager = session
        } else {
            let configuration = URLSessionConfiguration.af.default
            configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            configuration.timeoutIntervalForRequest = 5
            configuration.timeoutIntervalForResource = 5
            self.sessionManager =  Session(configuration: configuration)
        }
    }
}

//MARK: - Helpers
extension MovieService {
    func defaultParameters(additionalParameters: [String: String]? = nil) -> [String: String] {
        let language = NSLocalizedString("service-locale", comment: "")
        var params: [String: String] = ["language": language, "api_key": apiKey]
        
        if let sessionId = self.sessionId {
            params["session_id"] = sessionId
        }
        
        if let additionalParameters = additionalParameters {
            params.merge(additionalParameters) { _, new in new }
        }
        
        return params
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
    func getModel<T: Codable>(model: T.Type? = nil, endpoint: Endpoint, parameters: [String: String]? = nil) -> AnyPublisher<T, Error> {
        let url = urlforEndpoint(endpoint, parameters: parameters)
        
        return sessionManager.request(url)
            .validate()
            .publishDecodable(type: T.self, decoder: jsonDecoder())
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func getModels<T: Codable>(model: T.Type? = nil, endpoint: Endpoint, parameters: [String: String] = [:], page: Int = 1) -> AnyPublisher<([T], Int), Error> {
        var params = parameters
        params["page"] = String(page)
        params["region"] = "US"
        
        return getModel(model: ServiceModelsResult<T>.self, endpoint: endpoint, parameters: params)
            .map { ($0.results, $0.totalPages) }
            .eraseToAnyPublisher()
    }
    
    func successAction<T: Encodable>(endpoint: Endpoint, body: T?, method: HTTPMethod = .get) -> AnyPublisher<ServiceSuccessResult, Error>  {
        let url = urlforEndpoint(endpoint)
        
        return AF.request(url, method: method, parameters: body, encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: ServiceSuccessResult.self, decoder: jsonDecoder(keyDecodingStrategy: .convertFromSnakeCase))
            .value()
            .tryMap { result in
                guard let success = result.success, success == true else { throw ServiceError.noSuccess }
                
                return result
            }
            .eraseToAnyPublisher()
    }
    
    func successAction(endpoint: Endpoint, method: HTTPMethod = .get)  -> AnyPublisher<ServiceSuccessResult, Error> {
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
        
        print(url)
        
        return url
    }
}
