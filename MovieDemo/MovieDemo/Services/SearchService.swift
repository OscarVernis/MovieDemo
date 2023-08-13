//
//  SearchService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

enum SearchResultItem {
    case person(Person)
    case movie(Movie)
}

typealias SearchService = (_ query: String, _ page: Int) -> AnyPublisher<[SearchResultItem], Error>

typealias MovieSearchService = (_ query: String, _ page: Int) -> AnyPublisher<[Movie], Error>
