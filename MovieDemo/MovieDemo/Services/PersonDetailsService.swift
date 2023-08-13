//
//  PersonDetailsService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias PersonDetailsService = () -> AnyPublisher<Person, Error>
