//
//  MovieDetailsLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

protocol MovieDetailsLoader {
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error>
    
}
