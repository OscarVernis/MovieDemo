//
//  MoviesService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias MoviesService = (_ page: Int) -> AnyPublisher<[Movie], Error>

