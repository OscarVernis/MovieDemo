//
//  MovieServiceImageUtils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/10/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct MovieServiceImageUtils {
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
    
    static func watchProviderImageURL(forPath path: String) -> URL {
        var url = URL(string: baseImageURL)!
        url.appendPathComponent(MoviePosterSize.original.rawValue)
        
        return url.appendingPathComponent(path)
    }
    
}
