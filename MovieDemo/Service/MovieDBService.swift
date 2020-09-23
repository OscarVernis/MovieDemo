//
//  MovieDBService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct MovieDBService {
    enum ServiceError: Error {
        case jsonError
        case incorrectCredentials
    }
    
    let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    let baseURL = "https://api.themoviedb.org/3"
        
    func defaultParameters(withSessionId sessionId: String? = nil) -> [String: Any] {
        let language = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
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
}

//MARK: - Login
extension MovieDBService {
    func requestToken(completion: @escaping (String?, Error?) -> ()) {
        let url = endpoint(forPath: "/authentication/token/new")
        let params = defaultParameters()
        
        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                if let json = jsonData as? [String: Any], let token = json["request_token"] as? String {
                    completion(token, nil)
                } else {
                    completion(nil, ServiceError.jsonError)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func validateToken(username: String, password: String, requestToken: String, completion: @escaping (Bool, Error?) -> ()) {
        let url = endpoint(forPath: "/authentication/token/validate_with_login")
        let params = defaultParameters()

        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        
        AF.request(urlRequest.url!, method: .post, parameters: body, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                if let json = jsonData as? [String: Any], let success = json["success"] as? Bool {
                    completion(success, nil)
                } else {
                    completion(false, ServiceError.jsonError)
                }
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    func createSession(requestToken: String, completion: @escaping (String?, Error?) -> ()) {
        let url = endpoint(forPath: "/authentication/session/new")
        let params = defaultParameters()

        let body = ["request_token": requestToken]
        
        var urlRequest = URLRequest(url: url)
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        
        AF.request(urlRequest.url!, method: .post, parameters: body, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                if let json = jsonData as? [String: Any], let sessionId = json["session_id"] as? String {
                    completion(sessionId, nil)
                } else {
                    completion(nil, ServiceError.jsonError)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func deleteSession(sessionId: String, completion: @escaping (Bool, Error?) -> ()) {
        let url = endpoint(forPath: "/authentication/session")
        let params = defaultParameters()

        let body = ["session_id": sessionId]
        
        var urlRequest = URLRequest(url: url)
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        
        AF.request(urlRequest.url!, method: .delete, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                if let json = jsonData as? [String: Any], let success = json["success"] as? Bool {
                    completion(success, nil)
                } else {
                    completion(false, ServiceError.jsonError)
                }
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
}

//MARK: - User Actions
extension MovieDBService {
    private struct FavoriteRequestBody: Encodable {
        var media_type: String = "movie"
        var media_id: Int
        var favorite: Bool
    }
    
    private struct WatchlistRequestBody: Encodable {
        var media_type: String = "movie"
        var media_id: Int
        var watchlist: Bool
    }
    
    func fetchUserDetails(sessionId: String, completion: @escaping (User?, Error?) -> ()) {
        let url = endpoint(forPath: "/account")
        let params = defaultParameters(withSessionId: sessionId)

        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                guard let json = jsonData as? [String: Any] else {
                    completion(nil, ServiceError.jsonError)
                    return
                }
                
                let user = User(JSON: json)
                completion(user, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func markAsFavorite(_ favorite: Bool, movieId: Int, sessionId: String, completion: @escaping (Bool, Error?) -> ()) {
        let url = endpoint(forPath: "/account/id/favorite")
        let params = defaultParameters(withSessionId: sessionId)
        
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)
        
        var urlRequest = URLRequest(url: url)
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: params)

        AF.request(urlRequest.url!, method: .post, parameters: body, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                guard let json = jsonData as? [String: Any], let success = json["success"] as? Bool else {
                    completion(false, ServiceError.jsonError)
                    return
                }
                
                completion(success, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int, sessionId: String, completion: @escaping (Bool, Error?) -> ()) {
        let url = endpoint(forPath: "/account/id/watchlist")
        let params = defaultParameters(withSessionId: sessionId)
        
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)
        
        var urlRequest = URLRequest(url: url)
        urlRequest = try! Alamofire.URLEncoding.default.encode(urlRequest, with: params)

        AF.request(urlRequest.url!, method: .post, parameters: body, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                guard let json = jsonData as? [String: Any], let success = json["success"] as? Bool else {
                    completion(false, ServiceError.jsonError)
                    return
                }
                
                completion(success, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
}

//MARK: - Movie Lists
extension MovieDBService {
    private func fetchMovies(endpoint path: String, parameters: [String: Any] = [:], page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        let url = endpoint(forPath: path)
        
        var params = defaultParameters()
        params.merge(parameters) { _, new in new }
        params["page"] = page
        params["region"] = "US"
        
        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                if let json = jsonData as? [String: Any], let moviesData = json["results"] as? [[String: Any]] {
                    let movies = Array<Movie>.init(JSONArray: moviesData)
                    let totalPages = json["total_pages"] as? Int ?? page
                    
                    completion(movies, totalPages, nil)
                } else {
                    completion([], page, ServiceError.jsonError)
                }
            case .failure(let error):
                completion([], page, error)
            }
        }
    }
    
    func fetchNowPlaying(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/now_playing", page: page, completion: completion)
    }
    
    func fetchPopular(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/popular", page: page, completion: completion)
    }
    
    func fetchTopRated(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/top_rated", page: page, completion: completion)
    }
    
    func fetchUpcoming(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/upcoming", page: page, completion: completion)
    }
    
    func search(query: String, page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/search/movie", parameters: ["query" : query], page: page, completion: completion)
    }
    
    func fetchTrending(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/trending/movie/week", page: page, completion: completion)
    }
}

extension MovieDBService {
    //MARK: - Discover
    enum DiscoverOptions: String {
        case withCast = "with_cast"
        case withCrew = "with_crew"
    }
    
    func discover(params: [DiscoverOptions: Any], page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        //Convert the enum key to its string raw value
        let editedParams = Dictionary(uniqueKeysWithValues: params.map { ($0.rawValue, $1)})
        
        fetchMovies(endpoint: "/discover/movie", parameters: editedParams, page: page, completion: completion)
    }
}

//MARK: - Movie Details
extension MovieDBService {
    func fetchMovieDetails(movieId: Int, sessionId: String? = nil, completion: @escaping (Movie?, Error?) -> ()) {
        let url = endpoint(forPath: "/movie/\(movieId)")
        
        var params = defaultParameters(withSessionId: sessionId)
        params["append_to_response"] = "credits,recommendations,account_states"

        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                guard let json = jsonData as? [String: Any] else {
                    completion(nil, ServiceError.jsonError)
                    return
                }
                
                let movie = Movie(JSON: json)
                completion(movie, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchRecommendMovies(movieId: Int, page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/\(movieId)/recommendations", page: page, completion: completion)
    }
    
}
