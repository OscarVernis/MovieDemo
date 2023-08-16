//
//  MovieDetailsService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias MovieDetailsService = () -> AnyPublisher<Movie, Error>

typealias WatchProviderServiceResult = [Country: CountryWatchProviders]
typealias WatchProvidersService = () -> AnyPublisher<WatchProviderServiceResult, Error>
