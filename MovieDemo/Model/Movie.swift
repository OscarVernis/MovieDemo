//
//  Movie+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Alamofire
import ObjectMapper

public class Movie: Mappable {
    var backdropPath: String?
    var id: Int?
    var overview: String?
    var posterPath: String?
    var releaseDate: Date?
    var runtime: Int?
    var title: String?
    var voteAverage: Double?
    var cast: [CastCredit]?
    var crew: [CrewCredit]?
    
    
//MARK: - ObjectMapper
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        backdropPath <- map["backdrop_path"]
        id <- map["id"]
        overview <- map["overview"]
        posterPath <- map["poster_path"]
        releaseDate <- (map["release_date"], CustomDateFormatTransform(formatString: "yyyy-MM-dd"))
        title <- map["title"]
        voteAverage <- map["vote_average"]
        runtime <- map["runtime"]
        
    }
}

//MARK: - Requests
extension Movie {
//MARK: Fetch Movie Details
    
    func fetchDetails(completion: @escaping (Error?) -> ()) {
        guard let movieId = id else {
            completion(nil)
            return
        }
        
        let url = MovieDBService.endpoint(forPath: "/movie/\(movieId)")
        let params = MovieDBService.defaultParameters()
        
        Alamofire.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            guard response.result.isSuccess, let json = response.result.value as? [String: Any] else {
                completion(response.error)
                return
            }
            
            let map = Map(mappingType: .fromJSON, JSON: json)
            self.mapping(map: map)
            completion(nil)
        }
    }
    
    func fetchCredits(completion: @escaping (Error?) -> ()) {
        guard let movieId = id else {
            completion(nil)
            return
        }
        
        let url = MovieDBService.endpoint(forPath: "/movie/\(movieId)/credits")
        let params = MovieDBService.defaultParameters()
        
        Alamofire.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            guard response.result.isSuccess, let json = response.result.value as? [String: Any] else {
                completion(response.error)
                return
            }
            
            if let castData = json["cast"] as? [[String: Any]], let crewData = json["crew"] as? [[String: Any]] {
                self.cast = Array<CastCredit>.init(JSONArray: castData)
                self.crew = Array<CrewCredit>.init(JSONArray: crewData)
                
                completion(nil)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchRecommendMovies(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        guard let movieId = id else {
            completion([], 0, nil)
            return
        }
        
        Movie.fetchMovies(endpoint: "/movie/\(movieId)/recommendations", page: page) { movies, page, error in
            if error != nil {
                completion([], 0, error)
                return
            }
            
            completion(movies, page, error)
        }
    }
    
//MARK: Fetch list of movies
    
    private class func fetchMovies(endpoint path: String, parameters: [String: Any] = [:], page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        let url = MovieDBService.endpoint(forPath: path)
        
        var params = MovieDBService.defaultParameters()
        params.merge(parameters) { _, new in new }
        params["page"] = page
        //        params["region"] = "US"
        
        Alamofire.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            guard response.result.isSuccess, let json = response.result.value as? [String: Any] else {
                completion([], page, response.error)
                return
            }
            
            if let moviesData = json["results"] as? [[String: Any]] {
                let movies = Array<Movie>.init(JSONArray: moviesData)
                let totalPages = json["total_pages"] as? Int ?? page
                
                completion(movies, totalPages, nil)
            } else {
                completion([], page, nil)
            }
        }
    }
    
    class func fetchNowPlaying(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/now_playing", page: page, completion: completion)
    }
    
    class func fetchPopular(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/popular", page: page, completion: completion)
    }
    
    class func fetchTopRated(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/top_rated", page: page, completion: completion)
    }
    
    class func fetchUpcoming(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/movie/upcoming", page: page, completion: completion)
    }
    
    class func search(query: String, page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/search/movie", parameters: ["query" : query], page: page, completion: completion)
    }
    
    class func fetchTrending(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        fetchMovies(endpoint: "/trending/movie/week", page: page, completion: completion)
    }
    
}
