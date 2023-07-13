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
    static var moviesMock: JSONLoader<ServiceModelsResult<Movie>> {
        JSONLoader<ServiceModelsResult<Movie>>(filename: "now_playing")
    }
    
    static var movieVMs: [MovieViewModel] {
        moviesMock.model!.items.map(MovieViewModel.init)
    }
    
    static var moviesService: MoviesService {
        { (page: Int) in
            moviesMock.publisher()
                .map { result in
                    MoviesResult(movies: result.items, totalPages: result.totalPages)
                }
                .eraseToAnyPublisher()
            
        }
    }
    
    static var moviesProvider: MoviesProvider {
        MoviesProvider(service: moviesService)
    }
    
    //MARK: - Movie
    static var movieMock: JSONLoader<Movie> {
        JSONLoader<Movie>(filename: "movie")
    }
    
    static var movieVM: MovieViewModel {
        MovieViewModel(movie: movieMock.model!)
    }
    
    static func movieDetailStore(showUserActions: Bool) -> MovieDetailStore {
        let service: UserStateService? = showUserActions ? MockUserStatesService() : nil
        
        return MovieDetailStore(movie: movieVM, userStateService: service)
    }
    
    //MARK: - User
    static var userMock: JSONLoader<User> {
        JSONLoader<User>(filename: "user")
    }
    
    static var userProfileStore: UserProfileStore {
        UserProfileStore(service: userMock.publisher)
    }
    
}
