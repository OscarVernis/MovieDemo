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
    @Published var selectedCountry: Country {
        didSet {
            updateSelectedWatchProviders()
        }
    }
    
    let countries: [Country]
    let countriesWatchProviders: [Country: CountryWatchProviders]
    var selectedWatchProviders: [WatchProviderViewModel] = []
    var providerURL: URL? = nil
    
    init(countriesWatchProviders: [Country: CountryWatchProviders]) {
        self.countriesWatchProviders = countriesWatchProviders
        var countries = countriesWatchProviders.keys.sorted { $0.name < $1.name }
                
        //Try to find device region
        if let currentRegionCode = Locale.current.region?.identifier,
           let currentCountry = Country(countryCode: currentRegionCode) {
            
            //Put Device Country first on the list
            if let currentIdx = countries.firstIndex(of: currentCountry) {
                self.selectedCountry = currentCountry
                countries.remove(at: currentIdx)
                countries.insert(currentCountry, at: 0)
                
                self.countries = countries
                updateSelectedWatchProviders()
                return
            }
            
        }
        
        self.countries = countries
        
        //Use US region as fallback
        if let currentCountry = Country(countryCode: "US") {
            self.selectedCountry = currentCountry
            updateSelectedWatchProviders()
            return
        }
        
        //Just use first country
        self.selectedCountry = countries.first!
        updateSelectedWatchProviders()
    }
    
    func updateSelectedWatchProviders() {
        guard let countryWatchProvider = countriesWatchProviders[selectedCountry] else {
            selectedWatchProviders = []
            return
        }
        
        providerURL = URL(string: countryWatchProvider.link)
        
        var providers = [WatchProviderViewModel]()
        let streamingIds = countryWatchProvider.flatrate.map(\.id)
        let buyIds = countryWatchProvider.buy.map(\.id)
        let rentIds = countryWatchProvider.rent.map(\.id)
        var uniqueIds = Set<Int>()
        
        let allProviders = countryWatchProvider.flatrate + countryWatchProvider.buy + countryWatchProvider.rent
        for provider in allProviders {
            if uniqueIds.contains(provider.id) {
                continue
            }
            
            var types = [WatchProviderType]()
            if streamingIds.contains(provider.id) {
                types.append(.streaming)
            }
            
            if buyIds.contains(provider.id) {
                types.append(.buy)
            }
            
            if rentIds.contains(provider.id) {
                types.append(.rent)
            }
            
            let viewModel = WatchProviderViewModel(id: provider.id,
                                                   name: provider.providerName,
                                                   logoURL: MovieServiceImageUtils.watchProviderImageURL(forPath: provider.logoPath),
                                                   displayPriority: provider.displayPriority,
                                                   serviceTypes: types)
            providers.append(viewModel)
            uniqueIds.insert(provider.id)
        }
        
        selectedWatchProviders = providers
    }
    
}
