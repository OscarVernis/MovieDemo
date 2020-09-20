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
    }
    
    let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    
    let baseURL = "https://api.themoviedb.org/3"
    
    func defaultParameters() -> [String: Any] {
        let language = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
        let params = ["language": language, "api_key": apiKey]
        
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

//MARK: - Movie Details
extension MovieDBService {
    func fetchMovieDetails(movieId: Int, completion: @escaping (Movie?, Error?) -> ()) {
        let url = endpoint(forPath: "/movie/\(movieId)")
        var params = defaultParameters()
        params["append_to_response"] = "credits,recommendations"

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
