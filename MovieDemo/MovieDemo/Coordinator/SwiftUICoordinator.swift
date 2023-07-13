//
//  SwiftUICoordinator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import SwiftUI

class SwiftUICoordinator: MainCoordinator {
    override func showHome() {
        let homeView = Home(router: self,
                            nowPlayingProvider: dependencies.moviesProvider(for: .NowPlaying, cacheList: .NowPlaying),
                            upcomingProvider: dependencies.moviesProvider(for: .Upcoming, cacheList: .Upcoming),
                            popularProvider: dependencies.moviesProvider(for: .Popular, cacheList: .Popular),
                            topRatedProvider: dependencies.moviesProvider(for: .TopRated, cacheList: .TopRated))
            .tint(Color(asset: .AppTintColor))
        let hvc = UIHostingController(rootView: homeView)

        hvc.navigationItem.searchController = homeSearchController
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    override func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        let store = dependencies.movieDetailsStore(movie: movie)
        let movieDetail = MovieDetail(router: self, store: store)
        let mdvc = UIHostingController(rootView: movieDetail)
        mdvc.navigationItem.largeTitleDisplayMode = .never

        rootNavigationViewController?.pushViewController(mdvc, animated: animated)
    }
    
    override func showUserProfile(animated: Bool = true) {
        if isLoggedIn {
            let userProfile = UserProfile(store: dependencies.userProfileStore, router: self)
            let upvc = UIHostingController(rootView: userProfile)
            upvc.navigationItem.largeTitleDisplayMode = .never

            rootNavigationViewController?.pushViewController(upvc, animated: animated)
        } else {
            showLogin(animated: animated)
        }
    }
    
}
