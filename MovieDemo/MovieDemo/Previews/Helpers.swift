//
//  Helpers.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension MoviesLoader where Self == JSONMoviesLoader {
    static var mock: JSONMoviesLoader {
        JSONMoviesLoader(filename: "now_playing")
    }
}

extension MovieDetailsLoader where Self == JSONMovieDetailsLoader {
    static var mock: JSONMovieDetailsLoader {
        JSONMovieDetailsLoader(filename: "movie")
    }
}

extension UserLoader where Self == JSONUserLoader {
    static var mock: JSONUserLoader {
        JSONUserLoader(filename: "user")
    }
}

extension MovieViewModel {
    static var preview: MovieViewModel {
        JSONMovieDetailsLoader.mock.viewModel
    }
}

extension Collection where Element == MovieViewModel {
    static var preview: [MovieViewModel] {
        JSONMoviesLoader.mock.viewModels
    }
}

extension UserViewModel {
    static var preview: UserViewModel {
        UserViewModel(service: .mock, cache: nil)
    }
}

extension MovieDetailStore {
    static func preview(showUserActions: Bool) -> MovieDetailStore {
        let service: UserStateService? = showUserActions ? MockUserStatesService() : nil
        
        return MovieDetailStore(movie: .preview, userStateService: service)
    }
}
