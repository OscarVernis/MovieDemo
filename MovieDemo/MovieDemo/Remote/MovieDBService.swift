//
//  MovieDBService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import Alamofire
import Combine

struct MovieDBService {
    enum ServiceError: Error {
        case jsonError
        case incorrectCredentials
        case noSuccess
    }
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
    }
    
    private let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    private let baseURL = "https://api.themoviedb.org/3"
    let sessionId: String?
        
    func defaultParameters(withSessionId sessionId: String? = nil, additionalParameters: [String: Any]? = nil) -> [String: Any] {
        let language = NSLocalizedString("service-locale", comment: "")
        var params: [String: Any] = ["language": language, "api_key": apiKey]
        
        if let sessionId = sessionId {
            params["session_id"] = sessionId
        } else if let sessionId = self.sessionId {
            params["session_id"] = sessionId
        }
        
        if let additionalParameters = additionalParameters {
            params.merge(additionalParameters) { _, new in new }
        }
            
        return params
    }
    
    func endpoint(forPath path: String) -> URL {
        let url = URL(string: baseURL)!
        
        return url.appendingPathComponent(path)
    }
    
    func jsonDecoder(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        return Session(configuration: configuration)
    }()
}

//MARK: - Combine
extension MovieDBService {
    func getModels<T: Codable>(endpoint path: String, sessionId: String? = nil, parameters: [String: Any] = [:], page: Int = 1) -> AnyPublisher<([T], Int), Error> {
        var params = defaultParameters(withSessionId: sessionId, additionalParameters: parameters)
        params["page"] = page
        params["region"] = "US"
        
        return sessionManager.request(endpoint(forPath: path), parameters: params, encoding: URLEncoding.default)
            .validate()
            .publishDecodable(type: ServiceModelsResult<T>.self, decoder: jsonDecoder())
            .value()
            .mapError { _ in ServiceError.jsonError }
            .map { ($0.results, $0.totalPages) }
            .eraseToAnyPublisher()
    }
    
    func getModel<T: Codable>(path: String, parameters: [String: Any]?) -> AnyPublisher<T, Error> {
        let params = defaultParameters(withSessionId: sessionId, additionalParameters: parameters)

        return AF.request(endpoint(forPath: path), parameters: params, encoding: URLEncoding.default)
            .validate()
            .publishDecodable(type: T.self, decoder: jsonDecoder())
            .value()
            .mapError { _ in ServiceError.jsonError }
            .eraseToAnyPublisher()
    }
    
    func successAction(path: String, body: [String: String]? = nil, method: HTTPMethod = .get) -> AnyPublisher<ServiceSuccessResult, Error>  {
        
        var urlRequest = URLRequest(url: endpoint(forPath: path))
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: defaultParameters())
        
        return AF.request(urlRequest.url!, method: method, parameters: body, encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: ServiceSuccessResult.self, decoder: jsonDecoder(keyDecodingStrategy: .convertFromSnakeCase))
            .value()
            .tryMap { result in
                guard let success = result.success, success == true else { throw ServiceError.noSuccess }
                
                return result
            }
            .eraseToAnyPublisher()
    }
    
}

//MARK: - Generic Functions
extension MovieDBService {
    typealias SuccessActionCompletion = (Result<Void, Error>) -> Void
    typealias StringCompletion = (Result<String, Error>) -> Void
    
    func getModels<T: Codable>(endpoint path: String, sessionId: String? = nil, parameters: [String: Any] = [:], page: Int = 1, completion: @escaping ((Result<([T], Int), Error>) -> Void)) {
        let url = endpoint(forPath: path)
        
        var params = defaultParameters(withSessionId: sessionId, additionalParameters: parameters)
        params["page"] = page
        params["region"] = "US"

        sessionManager.request(url, parameters: params, encoding: URLEncoding.default).validate().responseDecodable(of: ServiceModelsResult<T>.self, decoder: jsonDecoder()) { response in
            switch response.result {
            case .success(let results):
                let models = results.results
                let totalPages = results.totalPages
                
                completion(.success((models, totalPages)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getModel<T: Codable>(url: URL, params: [String: Any], completion: @escaping (Result<T, Error>) -> ()) {
        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseDecodable(of: T.self, decoder: jsonDecoder()) { response in
            switch response.result {
            case .success(let model):
                completion(.success((model)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func successAction<T: Encodable>(url: URL, params: [String: Any], body: T? = (Optional<String>.none as! T), method: HTTPMethod = .get, completion: @escaping SuccessActionCompletion) {
        var urlRequest = URLRequest(url: url)
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        
        AF.request(urlRequest.url!, method: method, parameters: body, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                guard let json = jsonData as? [String: Any], let success = json["success"] as? Bool else {
                    completion(.failure(ServiceError.jsonError))
                    return
                }
                
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(ServiceError.noSuccess))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func successAction(url: URL, params: [String: Any], method: HTTPMethod = .get, completion: @escaping SuccessActionCompletion) {
        successAction(url: url, params: params, body: Optional<String>.none, method: method, completion: completion)
    }
    
}

//MARK: - Image Utils
extension MovieDBService {
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
    static let avatarImageURL = "https://www.gravatar.com/avatar/"
    
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
        var url = URL(string: avatarImageURL)!
        url.appendPathComponent(hash)
        
        return url
    }
}
