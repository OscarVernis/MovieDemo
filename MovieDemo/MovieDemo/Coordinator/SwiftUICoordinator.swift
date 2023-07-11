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
    private var remoteClient: TMDBClient {
        TMDBClient(sessionId: sessionId, httpClient: URLSessionHTTPClient())
    }
    
    override func showHome() {
        let homeView = Home(router: self,
                            nowPlayingProvider: moviesProvider(for: .NowPlaying, cacheList: .NowPlaying),
                            upcomingProvider: moviesProvider(for: .Upcoming, cacheList: .Upcoming),
                            popularProvider: moviesProvider(for: .Popular, cacheList: .Popular),
                            topRatedProvider: moviesProvider(for: .TopRated, cacheList: .TopRated))
            .tint(Color(asset: .AppTintColor))
        let hvc = UIHostingController(rootView: homeView)

        hvc.navigationItem.searchController = homeSearchController
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    override func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        let movieService = remoteClient.getMovieDetails(movieId: movie.id)
        let userStateService: RemoteUserStateService? = sessionId != nil ? RemoteUserStateService(sessionId: sessionId!) : nil
        let store = MovieDetailStore(movie: movie,
                                     movieService: movieService,
                                     userStateService: userStateService)
        
        let movieDetail = MovieDetail(router: self, store: store)
        let mdvc = UIHostingController(rootView: movieDetail)
        mdvc.navigationItem.largeTitleDisplayMode = .never

        rootNavigationViewController?.pushViewController(mdvc, animated: animated)
    }
    
    override func showUserProfile(animated: Bool = true) {
        if sessionId != nil {
            let cache = UserCache()
            let service = remoteClient.getUserDetails()
                .cache(with: cache)
                .placeholder(with: cache.publisher)
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
