//
//  CodableWatchProviders+Mapping.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension CodableWatchProvider {
    func toWatchProvider() -> WatchProvider? {
        if let provider_name {
            return WatchProvider(logoPath: logo_path ?? "",
                                 providerName: provider_name,
                                 displayPriority: display_priority ?? .max)
        } else {
            return nil
        }
    }
}

extension CodableCountryWatchProviders {
    func toCountryWatchProviders() -> CountryWatchProviders? {
        let rentWP = rent?.compactMap { $0.toWatchProvider() } ?? []
        let flatrateWP = flatrate?.compactMap { $0.toWatchProvider() } ?? []
        let buyWP = buy?.compactMap { $0.toWatchProvider() } ?? []
        
        if !rentWP.isEmpty || !flatrateWP.isEmpty || !buyWP.isEmpty {
            return CountryWatchProviders(link: link ?? "",
                                         rent: rentWP.sorted { $0.displayPriority < $1.displayPriority },
                                         flatrate: flatrateWP.sorted { $0.displayPriority < $1.displayPriority },
                                         buy: buyWP.sorted { $0.displayPriority < $1.displayPriority })
        } else {
            return nil
        }
    }
}

extension CodableWatchProvidersResult {
    func toWatchProviders() -> [Country: CountryWatchProviders] {
        var wp = [Country: CountryWatchProviders]()
        
        let countries: [Country] = results?.keys.compactMap { Country(countryCode: $0) } ?? []
        
        for country in countries {
            if let cwp = results?[country.countryCode]?.toCountryWatchProviders() {
                wp[country] = cwp
            }
        }
        
        return wp
    }
}
