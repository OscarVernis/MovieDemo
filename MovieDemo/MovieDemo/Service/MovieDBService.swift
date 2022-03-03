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
    
    private func fetchModels<T: BaseMappable>(endpoint path: String, sessionId: String? = nil, parameters: [String: Any] = [:], page: Int = 1, completion: @escaping ((Result<([T], Int), Error>) -> Void)) {
        let url = endpoint(forPath: path)
        
        var params = defaultParameters(withSessionId: sessionId)
        params.merge(parameters) { _, new in new }
        params["page"] = page
        params["region"] = "US"
        
        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                if let json = jsonData as? [String: Any], let modelsData = json["results"] as? [[String: Any]] {
                    let models = Array<T>.init(JSONArray: modelsData)
                    let totalPages = json["total_pages"] as? Int ?? page
                    
                    completion(.success((models, totalPages)))
                } else {
                    completion(.failure(ServiceError.jsonError))
                }
            case .failure(let error):
                completion(.failure(error))

            }
        }
    }
    
    func fetchModel<T: BaseMappable>(url: URL, params: [String: Any], completion: @escaping (Result<T, Error>) -> ()) {
        AF.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                guard let json = jsonData as? [String: Any] else {
                    completion(.failure(ServiceError.jsonError))
                    return
                }
                
                let model = Mapper<T>().map(JSON: json)!
                completion(.success(model))
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

//MARK: - Search
extension MovieDBService {
    func search(query: String, page: Int = 1, completion: @escaping (Result<([MediaItem], Int), Error>) -> Void) {
        fetchModels(endpoint: "/search/multi", parameters: ["query" : query], page: page, completion: completion)
    }
}

//MARK: - Movie Lists
extension MovieDBService {
    typealias MovieListCompletion = (Result<([Movie], Int), Error>) -> Void
    
    enum MovieList: Equatable {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
        case Search(query: String)
        case Trending
        case Recommended(movieId: Int)
        case DiscoverWithCast(castId: Int)
        case DiscoverWithCrew(crewId: Int)
        case UserFavorites
        case UserWatchList
        case UserRated
        
        var endpoint: String {
            switch self {
    
            case .NowPlaying:
                return "/movie/now_playing"
            case .Popular:
                return "/movie/popular"
            case .TopRated:
                return "/movie/top_rated"
            case .Upcoming:
                return "/movie/upcoming"
            case .Search(query: _):
                return "/search/movie"
            case .Trending:
                return "/movie/week"
            case .Recommended(movieId: let movieId):
                return "/movie/\(movieId)/recommendations"
            case .DiscoverWithCast(castId: _), .DiscoverWithCrew(crewId: _):
                return "/discover/movie"
            case .UserFavorites:
                return "/account/id/favorite/movies"
            case .UserWatchList:
                return "/account/id/watchlist/movies"
            case .UserRated:
                return "/account/id/rated/movies"
            }
        }
        
        var parameters: [String: Any] {
            switch self {
            case .Search(query: let query):
                return ["query" : query]
            case .DiscoverWithCast(castId: let castId):
                return ["with_cast": castId]
            case .DiscoverWithCrew(crewId: let crewId):
                return ["with_crew": crewId]
            default:
                return [:]
            }
        }
        
        var sessionId: String? {
            switch self {
            case .UserFavorites, .UserWatchList, .UserRated:
                return self.sessionId
            default:
                return nil
            }
        }
    }
    
    func fetchMovies(movieList: MovieList, page: Int = 1, completion: @escaping MovieListCompletion) {
        fetchModels(endpoint: movieList.endpoint, sessionId: movieList.sessionId, parameters: movieList.parameters, page: page, completion: completion)
    }

}

//MARK: - Movie Details
extension MovieDBService {
    func fetchMovieDetails(movieId: Int, sessionId: String? = nil, completion: @escaping ((Result<Movie, Error>)) -> ()) {
        let url = endpoint(forPath: "/movie/\(movieId)")
        
        var params = defaultParameters(withSessionId: sessionId)
        params["append_to_response"] = "credits,recommendations,account_states,videos"
        
        fetchModel(url: url, params: params, completion: completion)
    }
    
}

//MARK: - Person Details
extension MovieDBService {
    func fetchPersonDetails(personId: Int, completion: @escaping ((Result<Person, Error>)) -> ()) {
        let url = endpoint(forPath: "/person/\(personId)")
        
        var params = defaultParameters()
        params["append_to_response"] = "movie_credits"
        
        fetchModel(url: url, params: params, completion: completion)
    }
}

//MARK: - Login
extension MovieDBService {
    func requestToken(completion: @escaping FetchStringCompletion) {
        let url = endpoint(forPath: "/authentication/token/new")
        let params = defaultParameters()
        
        fetchString(path: "request_token", url: url, params: params, method: .get, completion: completion)
    }
    
    func validateToken(username: String, password: String, requestToken: String, completion: @escaping SuccessActionCompletion) {
        let url = endpoint(forPath: "/authentication/token/validate_with_login")
        let params = defaultParameters()

        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func createSession(requestToken: String, completion: @escaping FetchStringCompletion) {
        let url = endpoint(forPath: "/authentication/session/new")
        let params = defaultParameters()

        let body = ["request_token": requestToken]
        
        fetchString(path: "session_id", url: url, params: params, body: body, completion: completion)
    }
    
    func deleteSession(sessionId: String, completion: @escaping SuccessActionCompletion) {
        let url = endpoint(forPath: "/authentication/session")
        let params = defaultParameters()

        let body = ["session_id": sessionId]
        
        successAction(url: url, params: params, body: body, method: .delete, completion: completion)
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
    
    func fetchUserDetails(sessionId: String, completion: @escaping (Result<User, Error>) -> ()) {
        let url = endpoint(forPath: "/account/id")
        var params = defaultParameters(withSessionId: sessionId)
        params["append_to_response"] = "favorite/movies,rated/movies,watchlist/movies"
        
        fetchModel(url: url, params: params, completion: completion)
    }
    
    func fetchUserFavorites(sessionId: String, page: Int = 1, completion: @escaping MovieListCompletion) {
        fetchModels(endpoint: "/account/id/favorite/movies", sessionId: sessionId, page: page, completion: completion)
    }
    
    func fetchUserWatchlist(sessionId: String, page: Int = 1, completion: @escaping MovieListCompletion) {
        fetchModels(endpoint: "/account/id/watchlist/movies", sessionId: sessionId, page: page, completion: completion)
    }
    
    func fetchUserRatedMovies(sessionId: String, page: Int = 1, completion: @escaping MovieListCompletion) {
        fetchModels(endpoint: "/account/id/rated/movies", sessionId: sessionId, page: page, completion: completion)
    }
    
    func markAsFavorite(_ favorite: Bool, movieId: Int, sessionId: String, completion: @escaping SuccessActionCompletion) {
        let url = endpoint(forPath: "/account/id/favorite")
        let params = defaultParameters(withSessionId: sessionId)
        
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)

        successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int, sessionId: String, completion: @escaping SuccessActionCompletion) {
        let url = endpoint(forPath: "/account/id/watchlist")
        let params = defaultParameters(withSessionId: sessionId)
        
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)

        successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func rateMovie(_ rating: Float, movieId: Int, sessionId: String, completion: @escaping SuccessActionCompletion) {
        let url = endpoint(forPath: "/movie/\(movieId)/rating")
        let params = defaultParameters(withSessionId: sessionId)
        
        let body = ["value": rating]

        successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func deleteRate(movieId: Int, sessionId: String, completion: @escaping SuccessActionCompletion) {
        let url = endpoint(forPath: "/movie/\(movieId)/rating")
        let params = defaultParameters(withSessionId: sessionId)
            
        successAction(url: url, params: params, method: .delete, completion: completion)
    }
    
}
