//
//  MovieDBService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation

enum MoviePosterSize: String {
    case w92, w154, w185, w342, w500, w780, original
}

enum BackdropSize: String {
    case w300, w780, w1280, original
}

struct MovieDBService {
    static let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let baseImageURL = "https://image.tmdb.org/t/p/"
    
    static let language = "en-US"
    
    static func defaultParameters() -> [String: Any] {
        let params = ["language": MovieDBService.language, "api_key": MovieDBService.apiKey]
        
        return params
    }
    
    static func urlForEndpoint(_ endpoint: String) -> URL {
        let url = URL(string: MovieDBService.baseURL)!
        
        return url.appendingPathComponent(endpoint)
    }
    
    static func posterImageURL(forPath path: String, size: MoviePosterSize = .original) -> URL {
        var url = URL(string: MovieDBService.baseImageURL)!
        url.appendPathComponent(size.rawValue)
        
        return url.appendingPathComponent(path)
    }
}
