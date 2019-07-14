//
//  Movie+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Alamofire
import MagicalRecord
import ObjectMapper

@objc(Movie)
public class Movie: MappableManagedObject {
    
    //MARK: - ObjectMapper

    public override func mapping(map: Map) {
        backdropPath <- map["backdrop_path"]
        id <- map["id"]
        overview <- map["overview"]
        posterPath <- map["poster_path"]
        releaseDate <- (map["release_date"], CustomDateFormatTransform(formatString: "yyyy-MM-dd"))
        title <- map["title"]
        voteAverage <- map["vote_average"]
        runtime <- map["runtime"]

    }
    
    //MARK: - Requests
    //MARK: Fetch Movie Details

    func fetchDetails(completion: @escaping (Error?) -> ()) {
        let url = MovieDBService.urlForEndpoint("/movie/\(id)")
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
        let url = MovieDBService.urlForEndpoint("/movie/\(id)/credits")
        let params = MovieDBService.defaultParameters()
        
        Alamofire.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            guard response.result.isSuccess, let json = response.result.value as? [String: Any] else {
                completion(response.error)
                return
            }
            
            if let castData = json["cast"] as? [[String: Any]], let crewData = json["crew"] as? [[String: Any]] {
                let cast = Array<CastCredit>.init(JSONArray: castData)
                self.cast = NSSet(array: cast)
                
                let crew = Array<CrewCredit>.init(JSONArray: crewData)
                self.crew = NSSet(array: crew)
                
                completion(nil)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchRecommendMovies(page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        Movie.fetchMovies(endpoint: "/movie/\(id)/recommendations", page: page) { movies, page, error in
            if error != nil {
                completion([], 0, error)
                return
            }
            
            completion(movies, page, error)
        }
    }
    
    //MARK: Fetch list of movies
    
    private class func fetchMovies(endpoint: String, parameters: [String: Any] = [:], page: Int = 1, completion: @escaping ([Movie], Int, Error?) -> ()) {
        let url = MovieDBService.urlForEndpoint(endpoint)
        
        var params = MovieDBService.defaultParameters()
        params.merge(parameters) { _, new in new }
        params["page"] = page
//        params["region"] = "US"
        
        Alamofire.request(url, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            guard response.result.isSuccess, let json = response.result.value as? [String: Any] else {
                completion([], 0, response.error)
                return
            }
            
            if let moviesData = json["results"] as? [[String: Any]] {
                let movies = Array<Movie>.init(JSONArray: moviesData)
                let totalPages = json["total_pages"] as? Int ?? 1
                
                completion(movies, totalPages, nil)
            } else {
                completion([], 0, nil)
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
