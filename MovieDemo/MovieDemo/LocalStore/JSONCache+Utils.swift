//
//  JSONCache+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension JSONCache<[Movie]> {
    enum CacheList {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
    }
    
    static func cache(for list: CacheList) -> any ModelCache<[Movie]> {
        switch list {
        case .NowPlaying:
            return JSONCache<[Movie]>(filename: "nowplaying-cache.json")
        case .Popular:
            return JSONCache<[Movie]>(filename: "popular-cache.json")
        case .TopRated:
            return JSONCache<[Movie]>(filename: "toprated-cache.json")
        case .Upcoming:
            return JSONCache<[Movie]>(filename: "upcoming-cache.json")
        }
    }
}
    
extension JSONCache<User> {
    static var userCache: any ModelCache<User> {
        JSONCache<User>(filename: "user-cache.json")
    }
}
