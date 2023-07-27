//
//  Endpoint.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

//MARK: - Endpoint
struct Endpoint {
    var path: String
    
    let apiKey = "835d1e600e545ac8d88b4e62680b2a65"
    let baseURL = "api.themoviedb.org"
}

//MARK: - Helpers
extension Endpoint {
    private func defaultParameters(with additionalParameters: [String: String]? = nil, sessionId: String? = nil) -> [String: String] {
        let language = ServiceString.ServiceLocale.localized
        var params: [String: String] = ["language": language, "api_key": apiKey]
        
        if let sessionId = sessionId {
            params["session_id"] = sessionId
        }
        
        if let additionalParameters = additionalParameters {
            params.merge(additionalParameters) { _, new in new }
        }
        
        return params
    }
    
    func url(parameters: [String: String]? = nil, sessionId: String? = nil) -> URL {
        let path = self.path
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = "/3" + path
        
        let params = defaultParameters(with: parameters, sessionId: sessionId)
        components.queryItems = params.compactMap{ URLQueryItem(name: $0.0, value: $0.1) }
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
    
}

//MARK: - Movie Lists
extension Endpoint {
    static func movies(_ endpoint: MoviesEndpoint) -> Endpoint {
        Endpoint(path: endpoint.path)
    }
    
}

enum MoviesEndpoint: Equatable {
    case NowPlaying
    case Popular
    case TopRated
    case Upcoming
    case Recommended(movieId: Int)
    case UserFavorites
    case UserWatchList
    case UserRated
    
    var path: String {
        switch self {
        case .NowPlaying:
            return "/movie/now_playing"
        case .Popular:
            return "/movie/popular"
        case .TopRated:
            return "/movie/top_rated"
        case .Upcoming:
            return "/movie/upcoming"
        case .Recommended(movieId: let movieId):
            return "/movie/\(movieId)/recommendations"
        case .UserFavorites:
            return "/account/id/favorite/movies"
        case .UserWatchList:
            return "/account/id/watchlist/movies"
        case .UserRated:
            return "/account/id/rated/movies"
        }
    }
    
}

//MARK: - Search
extension Endpoint {
    static var search: Endpoint {
        Endpoint(path: "/search/multi")
    }
    
}

//MARK: - Details
extension Endpoint {
    static func movieDetails(movieId: Int) -> Endpoint {
        Endpoint(path: "/movie/\(movieId)")
    }
    
    static func personDetails(personId: Int) -> Endpoint {
        Endpoint(path: "/person/\(personId)")
    }
    
}

//MARK: - User
extension Endpoint {
    static var userDetails: Endpoint {
        Endpoint(path: "/account/id")
    }
    
    static var markAsFavorite: Endpoint {
        Endpoint(path: "/account/id/favorite")
    }
    
    static var addToWatchlist: Endpoint {
        Endpoint(path: "/account/id/watchlist")
    }
    
    static func rateMovie(_ movieId: Int) -> Endpoint {
        Endpoint(path: "/movie/\(movieId)/rating")
    }
    
    static func deleteRate(_ movieId: Int) -> Endpoint {
        Endpoint(path: "/movie/\(movieId)/rating")
    }
    
}

//MARK: - Session
extension Endpoint {
    static var requestToken: Endpoint {
        Endpoint(path: "/authentication/token/new")
    }
    
    static var validateToken: Endpoint {
        Endpoint(path: "/authentication/token/validate_with_login")
    }
    
    static var createSession: Endpoint {
        Endpoint(path: "/authentication/session/new")
    }
    
    static var deleteSession: Endpoint {
        Endpoint(path: "/authentication/session")
    }
    
}

//MARK: - Lists
extension Endpoint {
    static func userLists(userId: Int) -> Endpoint {
        Endpoint(path: "/account/\(userId)/lists")
    }
    
    static var createList: Endpoint {
        Endpoint(path: "/list")
    }
    
    static func deleteList(_ listId: Int) -> Endpoint {
        Endpoint(path: "/list/\(listId)")
    }
    
    static func clearList(_ listId: Int) -> Endpoint {
        Endpoint(path: "/list/\(listId)/clear")
    }
    
    static func userListDetails(_ listId: Int) -> Endpoint {
        Endpoint(path: "/list/\(listId)")
    }
    
    static func addMovie(toList listId: Int) -> Endpoint {
        Endpoint(path: "/list/\(listId)/add_item")
    }
    
    static func removeMovie(toList listId: Int) -> Endpoint {
        Endpoint(path: "/list/\(listId)/remove_item")
    }
}
