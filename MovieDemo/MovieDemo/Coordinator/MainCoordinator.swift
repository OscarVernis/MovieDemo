//
//  MainCoordinator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import SPStorkController
import SDWebImage
import SafariServices
import SwiftUI
import Kingfisher

class MainCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    //If set to true, it will force you to login before showing Home
    private var isLoginRequired: Bool = false
    
    //Set to true uses Web Auth, false uses username and password.
    private var usesWebLogin: Bool = true
    
    private var window: UIWindow
    private(set) var rootNavigationViewController: UINavigationController?
    
    var dependencies: AppDependencyContainer = AppDependencyContainer()
    
    var isLoggedIn: Bool {
        dependencies.isLoggedIn
    }
    
    init(window: UIWindow, isLoginRequired: Bool? = nil, usesWebLogin: Bool? = nil, dependencyContainer: AppDependencyContainer? = nil) {
        self.window = window
        
        if let isLoginRequired {
            self.isLoginRequired = isLoginRequired
        }
        
        if let usesWebLogin {
            self.usesWebLogin = usesWebLogin
        }
        
        if let dependencyContainer {
            self.dependencies = dependencyContainer
        }
    }
    
    //MARK: - Helpers
    func handle(error: UserFacingError, shouldDismiss viewController: UIViewController? = nil) {
        guard let sender = rootNavigationViewController?.visibleViewController else { return }
        let completion = {
            if viewController == self.rootNavigationViewController?.topViewController {
                self.rootNavigationViewController?.popViewController(animated: true)
            }
        }
        
        AlertManager.showErrorAlert(error.localizedDescription,
                                    color: error.alertColor,
                                    image: error.alertImage,
                                    sender: sender,
                                    completion: completion)
    }
    
    func open(url: URL) {
        let vc = SFSafariViewController(url: url)
        vc.transitioningDelegate = self
        
        let presenting = rootNavigationViewController?.topViewController?.presentedViewController ?? rootNavigationViewController?.topViewController
        
        presenting?.present(vc, animated: true)
    }
    
    func deleteCache() {
        CodableCache.deleteCache()
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        //Kingfisher
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        //try CoreDataStore.shared.resetStore()
    }
    
    //MARK: - App Start
    func start() {
        rootNavigationViewController = UINavigationController()
        
        window.rootViewController = rootNavigationViewController
        window.makeKeyAndVisible()
        
        if isLoginRequired && isLoggedIn == false {
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
        lvc.store = dependencies.loginViewStore
        
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
        lvc.service = dependencies.sessionManager
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
    
    
    func logout() {
        Task { @MainActor in
            do {
                try await dependencies.logoutService()
                if self.isLoginRequired {
                    self.showLogin(animated: true)
                }
                
                deleteCache()
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                
                let _ = self.rootNavigationViewController?.popToRootViewController(animated: true)
            } catch {
                handle(error: UserFacingError.logoutError)
            }
        }
        
    }
    
    var homeSearchController: UISearchController {
        let searchViewController = SearchViewController(store: dependencies.searchStore, router: self)
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchResultsUpdater = searchViewController
        searchController.delegate = searchViewController
        
        return searchController
    }
    
    func showHome() {
        let hvc = HomeViewController(router: self,
                                     nowPlayingProvider: dependencies.moviesProvider(for: .NowPlaying, cacheList: .NowPlaying),
                                     upcomingProvider: dependencies.moviesProvider(for: .Upcoming, cacheList: .Upcoming),
                                     popularProvider: dependencies.moviesProvider(for: .Popular, cacheList: .Popular),
                                     topRatedProvider: dependencies.moviesProvider(for: .TopRated, cacheList: .TopRated))
        
        hvc.navigationItem.searchController = homeSearchController
        
        let userAction = UIAction { _ in self.showUserProfile() }
        let listsAction = UIAction { _ in self.showUserLists() }
        
        if isLoggedIn {
            hvc.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: .asset(.person), primaryAction: userAction),
                UIBarButtonItem(image: UIImage(systemName: "list.and.film"), primaryAction: listsAction),
            ]
        } else {
            hvc.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: .asset(.person), primaryAction: userAction)]
        }
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    //MARK: - Common
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        let store = dependencies.movieDetailsStore(movie: movie)
        let mdvc = MovieDetailViewController(store: store, router: self)
        
        rootNavigationViewController?.pushViewController(mdvc, animated: animated)
    }
    
    func showMovieList(title: String, endpoint: MoviesEndpoint, animated: Bool = true)  {
        let dataProvider = dependencies.moviesProvider(for: endpoint)
        let lvc = ListViewController(provider: dataProvider, cellConfigurator: MovieInfoListCell.configure, router: self)
        lvc.title = title
        
        lvc.didSelectedItem = { [weak self] model in
            if let movie = model as? MovieViewModel {
                self?.showMovieDetail(movie: movie)
            }
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
    }
    
    //MARK: - Login
    func didFinishLoginProcess() {
        rootNavigationViewController?.dismiss(animated: true)
    }
    
    //MARK: - Home
    func showUserProfile(animated: Bool = true) {
        if isLoggedIn {
            let upvc = UserProfileViewController(store: dependencies.userProfileStore, router: self)

            rootNavigationViewController?.pushViewController(upvc, animated: animated)
        } else {
            showLogin(animated: animated)
        }
    }
    
    func showUserListDetail(list: UserList, animated: Bool = true) {
        let uldvc = UserListDetailViewController(store: dependencies.userListDetailStore(list: list), router: self)
        rootNavigationViewController?.pushViewController(uldvc, animated: animated)
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
    
    //MARK: - Movie Detail
    func showCrewCreditList(credits: [CrewCreditViewModel], animated: Bool = true) {
        let model = CrewCreditsViewModel(crewCredits: credits)
        let lvc = CrewCreditsViewController(viewModel: model)
        
        lvc.didSelectedItem = { [weak self] crewCredit in
            let person = crewCredit.person()
            self?.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
    }
    
    func showCastCreditList(credits: [CastCreditViewModel], animated: Bool = true) {
        let lvc = CastCreditsViewController(credits: credits)
        
        lvc.didSelectedItem = { [weak self] castCredit in
                let person = castCredit.person()
                self?.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
    }
    
    func showWhereToWatch(watchProviders: WatchProvidersViewModel) {
        let watchView = WhereToWatchView(viewModel: watchProviders, router: self)
        let vc = UIHostingController(rootView: watchView)
        rootNavigationViewController?.topViewController?.present(vc, animated: true)
    }
    
    func showRecommendedMovies(for movieId: Int) {
        showMovieList(title: .localized(MovieString.RecommendedMovies), endpoint: .Recommended(movieId: movieId))
    }
    
    func showPersonProfile(_ viewModel: PersonViewModel, animated: Bool = true) {
        let pvc = PersonDetailViewController()
        pvc.store = dependencies.personDetailStore(person: viewModel)
        pvc.router = self
        
        rootNavigationViewController?.pushViewController(pvc, animated: animated)
    }
    
    func showMovieRatingView(store: MovieDetailStore, successHandler: @escaping () -> ()) {
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
        
        mrvc.didUpdateRating = successHandler
        
        rootNavigationViewController?.visibleViewController?.present(mrvc, animated: true)
    }
    
    //MARK: - User Detail
    func showUserFavorites() {
        showMovieList(title: .localized(UserString.Favorites), endpoint: .UserFavorites)
    }
    
    func showUserWatchlist() {
        showMovieList(title: .localized(UserString.Watchlist), endpoint: .UserWatchList)
    }
    
    func showUserRated() {
        showMovieList(title: .localized(UserString.Rated), endpoint: .UserRated)
    }
    
    //MARK: - User Lists
    func showUserLists(animated: Bool = true) {
        let ulvc = UserListsViewController(store: dependencies.userListsDataStore, router: self)
        ulvc.title = "Lists"

        rootNavigationViewController?.pushViewController(ulvc, animated: animated)
    }
    
    func showAddMovieToList(title: String, delegate: AddMoviesToListViewControllerDelegate, animated: Bool = true) {
        let vc = AddMoviesToListViewController(recentMovies: dependencies.recentMovies,
                                               searchService: dependencies.movieSearchService,
                                               delegate: delegate)
        vc.title = title
        vc.navigationItem.largeTitleDisplayMode = .always
        
        let navCont = UINavigationController(rootViewController: vc)

        rootNavigationViewController?.present(navCont, animated: true)
    }
    
}

extension MainCoordinator: HomeRouter,
                           MovieDetailRouter,
                           PersonDetailRouter,
                           LoginRouter,
                           UserProfileRouter,
                           SearchViewRouter,
                           UserListsRouter,
                           UserListDetailRouter,
                           URLHandlingRouter
{ }
