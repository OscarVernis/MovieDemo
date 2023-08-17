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
    
    @Environment(\.dismiss) var dismiss
    
    private let margin: CGFloat = 20
    private let bottomPadding: CGFloat = 12
    
    var countryWatchProviders: CountryWatchProviders {
        viewModel.selectedWatchProvider
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    VStack(alignment: .leading, spacing: 0) {
                        justWatchView
                            .padding(.bottom, 20)
                        
                        countrySelectionView
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: margin, bottom: 20, trailing: margin))
                    .listRowSeparator(.hidden)
                    
                    if !countryWatchProviders.flatrate.isEmpty {
                        watchProviders(title: "Streaming", watchProviders: countryWatchProviders.flatrate)
                    }
                    
                    if !countryWatchProviders.buy.isEmpty  {
                        watchProviders(title: "Buy", watchProviders: countryWatchProviders.buy)
                    }
                    
                    if !countryWatchProviders.rent.isEmpty {
                        watchProviders(title: "Rent", watchProviders: countryWatchProviders.rent)
                    }

                }
                .listStyle(.plain)
            }
            .toolbar(content: {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .tint(.init(asset: .AppTintColor))
                        .font(.avenirNextMedium(size: 18))
                }

            })
            .navigationTitle("Where to Watch")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(asset: .AppBackgroundColor))
        }
    }
    
    func watchProviders(title: String, watchProviders: [WatchProvider]) -> some View {
        Group {
            sectionHeader(title: title)
            ForEach(watchProviders) { provider in
                WatchProviderRow(providerName: provider.providerName,
                                 url: viewModel.providerImageURL(for: provider.logoPath))
                    .onTapGesture {
                        if let url = self.viewModel.providerURL {
                            router?.open(url: url)
                        }
                    }
                    .listRowSeparator(.hidden)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: margin, bottom: bottomPadding, trailing: margin))
        }
    }
    
    var justWatchView: some View {
        HStack(alignment: .lastTextBaseline, spacing: 6) {
            Text("PROVIDED BY")
                .foregroundColor(.secondaryLabel)
                .font(.avenirNextCondensedDemiBold(size: 14))
            Image("JustWatch-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 14)
        }
    }
    
    var countrySelectionView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("WHERE ARE YOU WATCHING?")
                .font(.avenirNextCondensedDemiBold(size: 18))
            Menu {
                ForEach(viewModel.countries, id: \.self) { country in
                    Button(country.name, action: { setSelectedCountry(country) })
                }
            } label: {
                HStack(spacing: 8) {
                    Text(viewModel.selectedCountry.name)
                        .font(.avenirNextMedium(size: 17))
                    Image(systemName: "chevron.up.chevron.down")
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
    }
    
    func sectionHeader(title: String) -> some View {
        Text(title)
            .foregroundColor(.label)
            .font(.avenirNextDemiBold(size: 24))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    func setSelectedCountry(_ country: Country) {
        viewModel.selectedCountry = country
    }
}

struct MovieWatchProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        WhereToWatchView(viewModel: MockData.watchProviders)
    }
}
