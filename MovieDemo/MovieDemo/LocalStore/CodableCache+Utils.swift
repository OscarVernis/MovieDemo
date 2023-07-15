//
//  JSONCache+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension CodableCache<[Movie]> {
    enum CacheList {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
    }
    
    static func cache(for list: CacheList) -> any ModelCache<[Movie]> {
        switch list {
        case .NowPlaying:
            return CodableCache<[Movie]>(filename: "nowplaying-cache.json")
        case .Popular:
            return CodableCache<[Movie]>(filename: "popular-cache.json")
        case .TopRated:
            return CodableCache<[Movie]>(filename: "toprated-cache.json")
        case .Upcoming:
            return CodableCache<[Movie]>(filename: "upcoming-cache.json")
        }
    }
}
    
extension CodableCache<User> {
    static var userCache: any ModelCache<User> {
        CodableCache<User>(filename: "user-cache.json")
    }
}

extension CodableCache {
    static func deleteCache() {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: CodableCache<Movie>.cacheDir, includingPropertiesForKeys: nil)
            for file in files {
                try FileManager.default.removeItem(at: file)
            }
        } catch { }
    }
    
}
