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
    @ObservedObject var upcomingProvider = MoviesProvider(.Upcoming)
    @ObservedObject var popularProvider = MoviesProvider(.Popular)
    @ObservedObject var topRatedProvider = MoviesProvider(.TopRated)

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                MovieBannerRow(title: .localized(HomeString.NowPlaying),
                               movies: nowPlayingProvider.items)
                MoviePosterRow(title: .localized(HomeString.Upcoming),
                               movies: upcomingProvider.items)
                MoviePosterList(title: .localized(HomeString.Popular),
                                movies: popularProvider.items)
                RatedMovieList(title: .localized(HomeString.TopRated),
                               movies: limit(topRatedProvider.items, 10))
            }
        }
        .background(Color(asset: .AppBackgroundColor))
        .toolbar { navigationItems() }
        .onAppear(perform: refresh)
        .navigationTitle(HomeString.Movies.localized)
    }
    
    func limit(_ items: [MovieViewModel], _ limit: Int) -> [MovieViewModel] {
        if items.count < limit {
            return items
        }
        
        return Array(items.prefix(upTo: limit))
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
        upcomingProvider.refresh()
        popularProvider.refresh()
        topRatedProvider.refresh()
    }
}

struct Home_Previews: PreviewProvider {
    static let provider = MoviesProvider(
        movieLoader: JSONMovieLoader(filename: "now_playing"),
        cache: nil
    )
    
    static var previews: some View {
        NavigationView{
            Home(coordinator: nil,
                 nowPlayingProvider: provider,
                 upcomingProvider: provider,
                 popularProvider: provider,
                 topRatedProvider: provider)
            .preferredColorScheme(.dark)
        }
    }
}
