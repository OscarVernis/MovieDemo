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
    private var sessionManager = SessionManager.shared
    private var sessionId: String? {
        sessionManager.sessionId
    }
    override func showHome() {
        let homeView = Home(router: self,
                            nowPlayingProvider: moviesProvider(for: .NowPlaying, cacheList: .NowPlaying),
                            upcomingProvider: moviesProvider(for: .Upcoming, cacheList: .Upcoming),
                            popularProvider: moviesProvider(for: .Popular, cacheList: .Popular),
                            topRatedProvider: moviesProvider(for: .TopRated, cacheList: .TopRated))
            .tint(Color(asset: .AppTintColor))
        let hvc = UIHostingController(rootView: homeView)

        let searchViewController = SearchViewController(router: self)
        hvc.navigationItem.searchController = searchViewController.searchController
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    override func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        let userStateService: RemoteUserStateService? = sessionId != nil ? RemoteUserStateService(sessionId: sessionId!) : nil
        let store = MovieDetailStore(movie: movie,
                                     movieService: RemoteMovieDetailsLoader(sessionId: sessionId),
                                     userStateService: userStateService)
        
        let movieDetail = MovieDetail(router: self, store: store)
        let mdvc = UIHostingController(rootView: movieDetail)
        mdvc.navigationItem.largeTitleDisplayMode = .never

        rootNavigationViewController?.pushViewController(mdvc, animated: animated)
    }
    
    override func showUserProfile(animated: Bool = true) {
        if let sessionId {
            let service = RemoteUserLoader(sessionId: sessionId)
                .with(cache: UserCache())
            let store = UserProfileStore(service: service)
            let userProfile = UserProfile(store: store, router: self)
            let upvc = UIHostingController(rootView: userProfile)
            upvc.navigationItem.largeTitleDisplayMode = .never

            rootNavigationViewController?.pushViewController(upvc, animated: animated)
        } else {
            showLogin(animated: animated)
        }
    }
    
}
