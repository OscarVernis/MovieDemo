//
//  MainCoordinator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import SPStorkController

class MainCoordinator {
    private var window: UIWindow
    private(set) var rootNavigationViewController: UINavigationController?
    
    private var sessionManager = SessionManager.shared
    
    //If set to true, it will force you to login before showing Home
    private var isLoginRequired: Bool = false
    
    //Set to true uses Web Auth, false uses username and password.
    private var usesWebLogin: Bool = false
    
    init(window: UIWindow, isLoginRequired: Bool? = nil, usesWebLogin: Bool? = true) {
        self.window = window
        
        if let isLoginRequired = isLoginRequired {
            self.isLoginRequired = isLoginRequired
        }
        
        if let usesWebLogin = usesWebLogin {
            self.usesWebLogin = usesWebLogin
        }
    }
    
    //MARK: - Helpers
    func handle(error: UserFacingError, shouldDismiss: Bool = false) {
        guard let sender = rootNavigationViewController?.visibleViewController else { return }
        let completion = {
            if shouldDismiss {
                self.rootNavigationViewController?.popViewController(animated: true)
            }
        }
        
        AlertManager.showErrorAlert(error.localizedDescription,
                                    color: error.alertColor,
                                    image: error.alertImage,
                                    sender: sender,
                                    completion: completion)
    }
    
    func moviesProvider(for movieList: MoviesEndpoint, cacheList: MovieCache.CacheList? = nil) -> MoviesProvider {
        let loader = RemoteMoviesLoader(movieList: movieList, sessionId: sessionManager.sessionId)
        
        var cache: MovieCache? = nil
        if let cacheList {
            cache = MovieCache(cacheList: cacheList)
        }
        
        return MoviesProvider(movieLoader: loader, cache: cache)
    }
    
    //MARK: - App Start
    func start() {
        rootNavigationViewController = UINavigationController()
        rootNavigationViewController?.navigationBar.prefersLargeTitles = true
        rootNavigationViewController?.navigationBar.tintColor = .asset(.AppTintColor)
        rootNavigationViewController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)!
        ]
        rootNavigationViewController?.navigationBar.standardAppearance.largeTitleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-Bold", size: 34)!,
        ]
        
        window.rootViewController = rootNavigationViewController
        window.makeKeyAndVisible()
        
        if isLoginRequired && sessionManager.isLoggedIn == false {
            showLogin(animated: false)
        } else {
            showHome()
        }
        
    }
    
    func showLogin(animated: Bool = true) {
        if usesWebLogin {
            showWebLogin(animated: animated)
        } else {
            showDefaultLogin(animated: animated)
        }
    }
    
    func showDefaultLogin(animated: Bool = true) {
        let lvc = LoginViewController.instantiateFromStoryboard()
        lvc.store = LoginViewStore(sessionManager: sessionManager)
        
        lvc.showsCloseButton = !isLoginRequired
        if isLoginRequired {
            lvc.modalPresentationStyle = .overFullScreen
        }
        
        lvc.didFinishLoginProcess = { [weak self] in
            self?.didFinishLoginProcess()
        }
        
        rootNavigationViewController?.present(lvc, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            
            if self.isLoginRequired && self.rootNavigationViewController!.viewControllers.isEmpty {
                self.showHome()
            }
        })
    }
    
    func showWebLogin(animated: Bool = true) {
        let lvc = WebLoginViewController.instantiateFromStoryboard()
        lvc.sessionManager = sessionManager
        lvc.router = self
        
        lvc.showsCloseButton = !isLoginRequired
        if isLoginRequired {
            lvc.modalPresentationStyle = .overFullScreen
        }
        
        rootNavigationViewController?.present(lvc, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            
            if self.isLoginRequired && self.rootNavigationViewController!.viewControllers.isEmpty {
                self.showHome()
            }
        })
    }
    
    
    func logout(completion: (() -> Void)? = nil) {
        Task { @MainActor in
            let result = await sessionManager.logout()
            
            switch result {
            case .success():
                if self.isLoginRequired {
                    self.showLogin(animated: true)
                }
                
                //Delete cache
                let cache = UserCache()
                cache.delete()
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                
                let _ = self.rootNavigationViewController?.popToRootViewController(animated: true)
                completion?()
            case .failure(let error):
                handle(error: error)
                completion?()
            }
        }
    }
    
    func showHome() {
        let hvc = HomeViewController(router: self,
                                     nowPlayingProvider: moviesProvider(for: .NowPlaying, cacheList: .NowPlaying),
                                     upcomingProvider: moviesProvider(for: .Upcoming, cacheList: .Upcoming),
                                     popularProvider: moviesProvider(for: .Popular, cacheList: .Popular),
                                     topRatedProvider: moviesProvider(for: .TopRated, cacheList: .TopRated))
        
        let searchViewController = SearchViewController(coordinator: self)
        hvc.navigationItem.searchController = searchViewController.searchController
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    //MARK: - Common
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        let userStateService: RemoteUserStateService? = sessionManager.sessionId != nil ? RemoteUserStateService(sessionId: sessionManager.sessionId!) : nil
        let store = MovieDetailStore(movie: movie,
                                     movieService: RemoteMovieDetailsLoader(sessionId: sessionManager.sessionId),
                                     userStateService: userStateService)
        
        let mdvc = MovieDetailViewController(store: store)
        mdvc.router = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: animated)
    }
    
    func showMovieList<T: DataProvider>(title: String, dataProvider: T, animated: Bool = true) where T.Model == MovieViewModel {
        let dataSource = ProviderDataSource(dataProvider: dataProvider,
                                            reuseIdentifier: MovieInfoListCell.reuseIdentifier,
                                            cellConfigurator: MovieInfoListCell.configure)
        let lvc = ListViewController(dataSource: dataSource, coordinator: self)
        lvc.title = title
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
        
        lvc.didSelectedItem = { [weak self] index in
            guard index < dataProvider.itemCount else { return }
            
            let movie = dataProvider.item(atIndex: index)
            self?.showMovieDetail(movie: movie)
        }
        
    }
    
    fileprivate func showMovieList(title: String, endpoint: MoviesEndpoint, animated: Bool = true)  {
        let dataProvider = moviesProvider(for: endpoint)
        
        showMovieList(title: title, dataProvider: dataProvider, animated: animated)
    }
    
    //MARK: - Login
    func didFinishLoginProcess() {
        rootNavigationViewController?.dismiss(animated: true)
    }
    
    //MARK: - Home Router
    func showUserProfile(animated: Bool = true) {
        if let sessionId = sessionManager.sessionId {
            let user = UserViewModel(service: RemoteUserLoader(sessionId: sessionId))
            let upvc = UserProfileViewController(user: user, coordinator: self)
            
            rootNavigationViewController?.pushViewController(upvc, animated: animated)
        } else {
            showLogin(animated: animated)
        }
    }
    
    func showNowPlaying() {
        showMovieList(title: .localized(HomeString.NowPlaying), endpoint: .NowPlaying)
    }
    
    func showUpcoming() {
        showMovieList(title: .localized(HomeString.Upcoming), endpoint: .Upcoming)
    }
    
    func showPopular() {
        showMovieList(title: .localized(HomeString.Popular), endpoint: .Popular)
    }
    
    func showTopRated() {
        showMovieList(title: .localized(HomeString.TopRated), endpoint: .TopRated)
    }
    
    //MARK: - Movie Detail Router
    func showCrewCreditList(credits: [CrewCreditViewModel], animated: Bool = true) {
        let provider = BasicProvider(models: credits)
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: CreditPhotoListCell.reuseIdentifier,
                                            cellConfigurator: CreditPhotoListCell.configure)
        let lvc = ListViewController(dataSource: dataSource, coordinator: self)
        lvc.title =  MovieString.Crew.localized
        
        lvc.didSelectedItem = { index in
            if index >= provider.itemCount { return }
            
            let crewCredit = provider.item(atIndex: index)
            
            let person = crewCredit.person()
            self.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
    }
    
    func showCastCreditList(credits: [CastCreditViewModel], animated: Bool = true) {
        let provider = BasicProvider(models: credits)
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: CreditPhotoListCell.reuseIdentifier,
                                            cellConfigurator: CreditPhotoListCell.configure)
        let lvc = ListViewController(dataSource: dataSource, coordinator: self)
        lvc.title = MovieString.Cast.localized
        
        lvc.didSelectedItem = { index in
            if index >= provider.itemCount { return }
            
            let castCredit = provider.item(atIndex: index)
            
            let person = castCredit.person()
            self.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
    }
    
    func showRecommendedMovies(for movieId: Int) {
        showMovieList(title: .localized(MovieString.RecommendedMovies), endpoint: .Recommended(movieId: movieId))
    }
    
    func showPersonProfile(_ viewModel: PersonViewModel, animated: Bool = true) {
        let pvc = PersonDetailViewController.instantiateFromStoryboard()
        pvc.person = viewModel
        pvc.router = self
        
        rootNavigationViewController?.pushViewController(pvc, animated: animated)
    }
    
    func showMovieRatingView(store: MovieDetailStore, updateHandler: @escaping () -> ()) {
        let mrvc = MovieRatingViewController.instantiateFromStoryboard()
        mrvc.errorHandler = { [weak self] error in
            self?.handle(error: error)
        }
        mrvc.store = store
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        mrvc.transitioningDelegate = transitionDelegate
        mrvc.modalPresentationStyle = .custom
        mrvc.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.customHeight = 450
        transitionDelegate.showIndicator = false
        
        mrvc.didUpdateRating = updateHandler
        
        rootNavigationViewController?.visibleViewController?.present(mrvc, animated: true)
    }

    //MARK: - User Detail Router
    func showUserFavorites() {
        showMovieList(title: .localized(UserString.Favorites), endpoint: .UserFavorites)
    }
    
    func showUserWatchlist() {
        showMovieList(title: .localized(UserString.Watchlist), endpoint: .UserWatchList)
    }
    
    func showUserRated() {
        showMovieList(title: .localized(UserString.Rated), endpoint: .UserRated)
    }
    
}

extension MainCoordinator: HomeRouter, MovieDetailRouter, PersonDetailRouter, LoginRouter { }
