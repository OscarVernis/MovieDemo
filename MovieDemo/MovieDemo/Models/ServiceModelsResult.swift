//
//  ServiceModelsResult.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct ServiceModelsResult<T: Codable>: Codable {
    var results: [T]
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }
}