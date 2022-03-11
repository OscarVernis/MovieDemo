//
//  MovieDBService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import Alamofire
import KeyedCodable

struct MovieDBService {
    enum ServiceError: Error {
        case jsonError
        case incorrectCredentials
        case noSuccess
    }
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
    }
    
    let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    let baseURL = "https://api.themoviedb.org/3"
    let sessionId: String?
        
    func defaultParameters(withSessionId sessionId: String? = nil) -> [String: Any] {
        let language = NSLocalizedString("service-locale", comment: "")
        var params = ["language": language, "api_key": apiKey]
        
        if let sessionId = sessionId {
            params["session_id"] = sessionId
        }
        
        return params
    }
    
    func endpoint(forPath path: String) -> URL {
        let url = URL(string: baseURL)!
        
        return url.appendingPathComponent(path)
    }
}

//MARK: - Generic Functions
extension MovieDBService {
    typealias SuccessActionCompletion = (Result<Void, Error>) -> Void
    typealias FetchStringCompletion = (Result<String, Error>) -> Void
    
    func fetchModels<T: Codable>(endpoint path: String, sessionId: String? = nil, parameters: [String: Any] = [:], page: Int = 1, completion: @escaping ((Result<([T], Int), Error>) -> Void)) {
        let url = endpoint(forPath: path)
        
        var params = defaultParameters(withSessionId: sessionId)
        params.merge(parameters) { _, new in new }
        params["page"] = page
        params["region"] = "US"
        
        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let jsonData):
                do {
                    let results = try ServiceModelsResult<T>.keyed.fromJSON(jsonData)
                    let models = results.results
                    let totalPages = results.totalPages
                    
                    print(results)
                    print(totalPages)
                    
                    completion(.success((models, totalPages)))
                } catch {
                    print(error)
                    completion(.failure(ServiceError.jsonError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchModel<T: Codable>(url: URL, params: [String: Any], completion: @escaping (Result<T, Error>) -> ()) {
        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(_):
                if let model = response.value {
                    completion(.success((model)))
                } else {
                    completion(.failure(ServiceError.jsonError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchString(path: String, url: URL, params: [String: Any], body: [String: String]? = nil, method: HTTPMethod = .post, completion: @escaping FetchStringCompletion) {
        var urlRequest = URLRequest(url: url)
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        
        AF.request(urlRequest.url!, method: method, parameters: body, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                if let json = jsonData as? [String: Any], let resultString = json[path] as? String {
                    completion(.success(resultString))
                } else {
                    completion(.failure(ServiceError.jsonError))
                }
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
