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
    @ObservedObject var nowPlayingProvider: MoviesProvider
    @ObservedObject var upcomingProvider: MoviesProvider
    @ObservedObject var popularProvider: MoviesProvider
    @ObservedObject var topRatedProvider: MoviesProvider
    
    private var topSectionPadding: CGFloat = 10

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                SectionTitle(title: .localized(HomeString.NowPlaying), tapAction: showNowPlaying)
                MovieBannerRow(movies: nowPlayingProvider.items,
                               tapAction: showDetail)
                
                SectionTitle(title: .localized(HomeString.Upcoming), tapAction: showUpcoming)
                    .padding(.top, topSectionPadding)
                PosterRow(movies: upcomingProvider.items,
                               tapAction: showDetail)

                SectionTitle(title: .localized(HomeString.Popular), tapAction: showPopular)
                    .padding(.top, topSectionPadding)
                MoviePosterList(movies: popularProvider.items,
                                tapAction: showDetail)
                
                SectionBackground {
                    SectionTitle(title: .localized(HomeString.TopRated), tapAction: showTopRated)
                        .padding(.top, 10)
                    RatedMovieList(movies: limit(topRatedProvider.items, 10),
                                   tapAction: showDetail)
                    .padding(.top, 8)
                }
                .padding(.top, topSectionPadding + 10)
            }
        }
        .background(Color(asset: .AppBackgroundColor))
        .toolbar { navigationItems() }
        .onAppear(perform: refresh)
        .navigationTitle(HomeString.Movies.localized)
    }
    
    //MARK: - Init
    init(coordinator: MainCoordinator? = nil,
         nowPlayingProvider: MoviesProvider,
         upcomingProvider: MoviesProvider,
         popularProvider: MoviesProvider,
         topRatedProvider: MoviesProvider) {
        self.coordinator = coordinator
        self.nowPlayingProvider = nowPlayingProvider
        self.upcomingProvider = upcomingProvider
        self.popularProvider = popularProvider
        self.topRatedProvider = topRatedProvider
    }
    
    //MARK: - Navigation
    fileprivate func showNowPlaying() {
        coordinator?.showMovieList(title: .localized(HomeString.NowPlaying), list: .NowPlaying)
    }
    
    fileprivate func showUpcoming() {
        coordinator?.showMovieList(title: .localized(HomeString.Upcoming), list: .Upcoming)
    }
    
    fileprivate func showPopular() {
        coordinator?.showMovieList(title: .localized(HomeString.Popular), list: .Popular)
    }
    
    fileprivate func showTopRated() {
        coordinator?.showMovieList(title: .localized(HomeString.TopRated), list: .TopRated)
    }
    
    fileprivate func showDetail(movie: MovieViewModel) {
        coordinator?.showMovieDetail(movie: movie)
    }
    
    //MARK: - Helpers
    fileprivate func refresh() {
        nowPlayingProvider.refresh()
        upcomingProvider.refresh()
        popularProvider.refresh()
        topRatedProvider.refresh()
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
    
    fileprivate func limit(_ items: [MovieViewModel], _ limit: Int) -> [MovieViewModel] {
        if items.count < limit {
            return items
        }
        
        return Array(items.prefix(upTo: limit))
    }
    
}

//MARK: - Previews
struct Home_Previews: PreviewProvider {
    static let provider = MoviesProvider(
        movieLoader: .mock,
        cache: nil
    )
    
    static var previews: some View {
        NavigationView{
            Home(coordinator: nil,
                 nowPlayingProvider: provider,
                 upcomingProvider: provider,
                 popularProvider: provider,
                 topRatedProvider: provider)
            .tint(Color(asset: .AppTintColor))
            .preferredColorScheme(.dark)
        }
    }
}
