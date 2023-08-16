//
//  WatchProvidersViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class WatchProvidersViewModel {
    let countries: [Country]
    let availableWatchProviders: [WatchProvider]
    
    init(countriesWatchProviders: [Country: CountryWatchProviders]) {
        self.countries = countriesWatchProviders.keys.sorted { $0.name < $1.name }
        
        //Try to find device region
        if let currentRegionCode = Locale.current.region?.identifier,
           let currentCountry = Country(countryCode: currentRegionCode),
           let cwp = countriesWatchProviders[currentCountry] {
            availableWatchProviders = cwp.flatrate + cwp.rent + cwp.buy
            return
        }
        
        //Use US region as fallback
        if let currentCountry = Country(countryCode: "US"),
           let cwp = countriesWatchProviders[currentCountry] {
            availableWatchProviders = cwp.flatrate + cwp.rent + cwp.buy
            return
        }
        
        //Just use first country
        if let currentCountry = countries.first,
           let cwp = countriesWatchProviders[currentCountry] {
            availableWatchProviders = cwp.flatrate + cwp.rent + cwp.buy
            return
        }
        
        availableWatchProviders = []
    }
    
}
