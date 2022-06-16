//
//  Home.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct Home: View {
    weak var coordinator: MainCoordinator?
    @ObservedObject var nowPlayingProvider = MoviesProvider(.NowPlaying)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                SectionTitle(title: .localized(HomeString.Upcoming))
                MoviePosterRow(movies: nowPlayingProvider.items)
                SectionTitle(title: .localized(HomeString.NowPlaying))
                MovieBannerRow(movies: nowPlayingProvider.items)
            }
        }
        .background(Color(asset: .AppBackgroundColor))
        .toolbar { navigationItems() }
        .onAppear(perform: refresh)
        .navigationTitle(HomeString.Movies.localized)
    }
    
    fileprivate func navigationItems() -> ToolbarItem<Void, Button<Image>> {
        ToolbarItem(placement: .primaryAction) {
            Button(action: {
                coordinator?.showUserProfile()
            }, label: {
                Image(asset: .person)
            })
        }
    }
    
    func refresh() {
        nowPlayingProvider.refresh()
    }
}

struct Home_Previews: PreviewProvider {
    static let provider = MoviesProvider(
        movieLoader: JSONMovieLoader(filename: "now_playing"),
        cache: nil
    )
    
    static var previews: some View {
        NavigationView{
            Home(coordinator: nil, nowPlayingProvider: provider)
                .preferredColorScheme(.light)
        }
        .tint(Color(asset: .AppTintColor))
    }
}
