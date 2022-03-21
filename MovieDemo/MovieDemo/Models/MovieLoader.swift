//
//  MovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

enum MovieList: Equatable {
    case NowPlaying
    case Popular
    case TopRated
    case Upcoming
    case Trending
    case Recommended(movieId: Int)
    case UserFavorites
    case UserWatchList
    case UserRated
}

protocol MovieLoader {
    typealias MovieListCompletion = (Result<([Movie], Int), Error>) -> Void
    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<([Movie], Int), Error>

//    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion)
}
