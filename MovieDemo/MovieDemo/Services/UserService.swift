//
//  UserService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias UserService = () -> AnyPublisher<User, Error>
