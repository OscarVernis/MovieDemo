//
//  MoviesService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias MoviesResult = (movies: [Movie], totalPages: Int)

typealias MoviesService = (_ page: Int) -> AnyPublisher<MoviesResult, Error>

