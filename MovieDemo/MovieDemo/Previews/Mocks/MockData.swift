//
//  MockData.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct MockData {
    
    //MARK: - Movies
    static var moviesMock: JSONLoader<ServiceModelsResult<CodableMovie>> {
        JSONLoader<ServiceModelsResult<CodableMovie>>(filename: "now_playing")
    }
    
    static var movieVMs: [MovieViewModel] {
        moviesMock.model!.items.toMovies().map(MovieViewModel.init)
    }
    
    static var moviesService: (Int) -> AnyPublisher<[MovieViewModel], Error> {
        { (page: Int) in
            moviesMock.publisher()
                .map { result in
                    return result.items.toMovies().map(MovieViewModel.init)
                }
                .eraseToAnyPublisher()
        }
    }
    
    static var moviesProvider: MoviesProvider {
        PaginatedProvider(service: moviesService)
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
    
    static var watchProviders: WatchProvidersViewModel {
        let jsonLoader = JSONLoader<CodableWatchProvidersResult>(filename: "watch_providers")
        let watchProviders = jsonLoader.model!.toWatchProviders()
        return WatchProvidersViewModel(countriesWatchProviders: watchProviders)
    }
    
    static var movieVideos: [MovieVideoViewModel] {
        return movieVM.videos
    }
    
    //MARK: - User
    static var userMock: JSONLoader<CodableUser> {
        JSONLoader<CodableUser>(filename: "user")
    }
    
    static var userProfileStore: UserProfileStore {
        let service = userMock.publisher().map { $0.toUser() }.eraseToAnyPublisher()
        return UserProfileStore(service: service)
    }
    
    //MARK: - Person
    static var personMock: JSONLoader<CodablePerson> {
        JSONLoader<CodablePerson>(filename: "person")
    }
    
    static var personDetailStore: PersonDetailStore {
        let person = personMock.model!.toPerson()
        return PersonDetailStore(person: PersonViewModel(person: person))
    }
    
    static var personVM: PersonViewModel {
        PersonViewModel(person: personMock.model!.toPerson())
    }
    
}
