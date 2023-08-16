//
//  CodableWatchProviders.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct CodableWatchProvidersResult: Codable {
    var results: [String: CodableCountryWatchProviders]?
}

struct CodableCountryWatchProviders: Codable {
    var link: String?
    var rent: [CodableWatchProvider]?
    var flatrate: [CodableWatchProvider]?
    var buy: [CodableWatchProvider]?
}

struct CodableWatchProvider: Codable {
    var logo_path: String?
    var provider_name: String?
    var display_priority: Int?
}
