//
//  WatchProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct Country: Hashable {
    var name: String
    var countryCode: String
    
    init?(countryCode: String) {
        self.countryCode = countryCode
        if let name = Locale.current.localizedString(forRegionCode: countryCode) {
            self.name = name
        } else {
            return nil
        }
    }
}

struct WatchProvider: Codable {
    var logoPath: String
    var providerName: String
    var displayPriority: Int
}

struct CountryWatchProviders: Codable {
    var link: String
    var rent: [WatchProvider]
    var flatrate: [WatchProvider]
    var buy: [WatchProvider]
}
