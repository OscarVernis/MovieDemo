//
//  MockData.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct MockData {
    
    //MARK: - Movies
    static var moviesMock: JSONLoader<ServiceModelsResult<CodableMovie>> {
        JSONLoader<ServiceModelsResult<CodableMovie>>(filename: "now_playing")
    }
    
    static var movieVMs: [MovieViewModel] {
        moviesMock.model!.items.map { MovieViewModel(movie: $0.toMovie()) }
    }
    
    static var moviesService: MoviesService {
        { (page: Int) in
            moviesMock.publisher()
                .map { result in
                    let movies = result.items.map { $0.toMovie() }
                    return MoviesResult(movies: movies, totalPages: result.totalPages)
                }
                .eraseToAnyPublisher()
            
        }
    }
    
    static var moviesProvider: MoviesProvider {
        MoviesProvider(service: moviesService)
    }
    
    //MARK: - Movie
    static var movieMock: JSONLoader<CodableMovie> {
        JSONLoader<CodableMovie>(filename: "movie")
    }
    
    static var movieVM: MovieViewModel {
        MovieViewModel(movie: movieMock.model!.toMovie())
    }
    
    static func movieDetailStore(showUserActions: Bool) -> MovieDetailStore {
        let service: UserStateService? = showUserActions ? MockUserStatesService() : nil
        
        return MovieDetailStore(movie: movieVM, userStateService: service)
    }
    
    //MARK: - User
    static var userMock: JSONLoader<CodableUser> {
        JSONLoader<CodableUser>(filename: "user")
    }
    
    static var userProfileStore: UserProfileStore {
        let service = userMock.publisher().map { $0.toUser() }.eraseToAnyPublisher()
        return UserProfileStore(service: service)
    }
    
}