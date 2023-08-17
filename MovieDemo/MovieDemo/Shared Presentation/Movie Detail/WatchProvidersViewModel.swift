//
//  WatchProvidersViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class WatchProvidersViewModel: ObservableObject {
    @Published var selectedCountry: Country

    let countries: [Country]
    let countriesWatchProviders: [Country: CountryWatchProviders]
    
    convenience init() {
        self.init(countriesWatchProviders: [:])
    }
    
    init(countriesWatchProviders: [Country: CountryWatchProviders]) {
        self.countriesWatchProviders = countriesWatchProviders
        self.countries = countriesWatchProviders.keys.sorted { $0.name < $1.name }
        
        //Try to find device region
        if let currentRegionCode = Locale.current.region?.identifier,
           let currentCountry = Country(countryCode: currentRegionCode) {
            self.selectedCountry = currentCountry
            return
        }
        
        //Use US region as fallback
        if let currentCountry = Country(countryCode: "US") {
            self.selectedCountry = currentCountry
            return
        }
        
        //Just use first country
        self.selectedCountry = countries.first!
    }
    
    var selectedWatchProvider: CountryWatchProviders {
        return countriesWatchProviders[selectedCountry] ?? CountryWatchProviders(link: "", rent: [], flatrate: [], buy: [])
    }

}
