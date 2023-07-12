//
//  SearchService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias SearchResult = (items: [Any], totalPages: Int)

typealias SearchService = (_ query: String, _ page: Int) -> AnyPublisher<SearchResult, Error>
