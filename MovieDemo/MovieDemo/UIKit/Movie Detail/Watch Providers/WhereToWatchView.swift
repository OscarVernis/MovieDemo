//
//  MovieWatchProvidersView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct WhereToWatchView: View {
    @ObservedObject var viewModel: WatchProvidersViewModel
    var router: URLHandlingRouter?
        
    private let margin: CGFloat = 20
    private let bottomPadding: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                countrySelectionView
                    .padding(.bottom, bottomPadding)
                
                if !viewModel.selectedWatchProviders.isEmpty {
                    sectionHeader(title: WatchProviderString.AvailableOn.localized)
                    availableProviders
                }
                
                attributionView
            }
            .listStyle(.plain)
        }
        .background(Color(asset: .AppBackgroundColor))
    }
    
    var availableProviders: some View {
        ForEach(viewModel.selectedWatchProviders) { provider in
            WatchProviderRow(title: provider.name,
                             description: provider.servicesString,
                             url: provider.logoURL)
            .onTapGesture {
                if let url = self.viewModel.providerURL {
                    router?.open(url: url)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: margin, bottom: bottomPadding, trailing: margin))
    }
    
    func sectionHeader(title: String) -> some View {
        Text(title)
            .foregroundColor(.label)
            .font(.avenirNextCondensedDemiBold(size: 22))
            .listRowInsets(EdgeInsets(top: 0, leading: margin, bottom: bottomPadding, trailing: margin))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    var countrySelectionView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(WatchProviderString.WhereAreYouWatching.localized)
                .font(.avenirNextCondensedDemiBold(size: 18))
            Menu {
                ForEach(viewModel.countries, id: \.self) { country in
                    Button(country.name, action: { setSelectedCountry(country) })
                }
            } label: {
                HStack(spacing: 8) {
                    Text(viewModel.selectedCountry.name)
                        .font(.avenirNextMedium(size: 17))
                    Image(asset: .updownchevron)
                }
            }
            .transaction { (tx: inout Transaction) in // Disable animation
                tx.disablesAnimations = true
                tx.animation = nil
            }
            .accentColor(Color.purple)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    var attributionView: some View {
        HStack(alignment: .lastTextBaseline, spacing: 6) {
            Text(WatchProviderString.ProvidedBy.localized)
                .foregroundColor(.secondaryLabel)
                .font(.avenirNextCondensedDemiBold(size: 14))
            Image(asset: .justWatchLogo)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 14)
            Text(WatchProviderString.And.localized)
                .foregroundColor(.secondaryLabel)
                .font(.avenirNextCondensedDemiBold(size: 14))
            Image(asset: .tmdbLogo)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 13)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    func setSelectedCountry(_ country: Country) {
        viewModel.selectedCountry = country
    }
}

struct MovieWatchProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WhereToWatchView(viewModel: MockData.watchProviders)
                .navigationTitle("Where to Watch")
        }
    }
}
