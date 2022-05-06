//
//  SearchLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

protocol SearchLoader {
    func search(query: String, page: Int) -> AnyPublisher<([Any], Int), Error>
}
