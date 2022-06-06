//
//  CoordinatorTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class CoordinatorTests: XCTestCase {
    var window: UIWindow!
    var navCont: UINavigationController? {
        window.rootViewController as? UINavigationController
    }
    
    override func setUpWithError() throws {
        window = UIWindow()
    }
    
    override func tearDownWithError() throws {
        SessionManager.shared.store = KeychainSessionStore()
        navCont?.viewControllers = []
        window = nil
    }
    
    func test_Coordinator_Loads_Home() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let home = navCont?.visibleViewController
        XCTAssert(home is HomeViewController)
    }
    
    func test_Coordinator_Loads_Login() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: true)
        
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(isLoggedIn: false)
        
        coordinator.start()
        
        let login = navCont?.visibleViewController
        XCTAssert(login is LoginViewController)
    }
    
    func test_Coordinator_Shows_MovieDetail() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        coordinator.showMovieDetail(movie: anyMovieVM(), animated: false)
        
        let movieDetail = navCont?.visibleViewController
        XCTAssert(movieDetail is MovieDetailViewController)
    }
    
    func test_Coordinator_Shows_MovieList() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let movie = anyMovieVM()
        coordinator.showMovieList(title: "Movies",
                                  dataProvider: StaticArrayDataProvider(models: movie.recommendedMovies),
                                  animated: false)
        
        let movieList = navCont?.visibleViewController
        XCTAssert(movieList is ListViewController)
    }
    
    func test_Coordinator_Shows_PersonDetail() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        coordinator.showPersonProfile(anyPersonVM(), animated: false)
        
        let personDetail = navCont?.visibleViewController
        XCTAssert(personDetail is PersonDetailViewController)
    }
    
    func test_Coordinator_Shows_CastList() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let movie = anyMovieVM()
        coordinator.showCastCreditList(title: "Cast",
                                       dataProvider: StaticArrayDataProvider(models: movie.cast),
                                       animated: false)
        
        let castList = navCont?.visibleViewController
        XCTAssert(castList is ListViewController)
    }
    
    func test_Coordinator_Shows_CrewList() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let movie = anyMovieVM()
        coordinator.showCrewCreditList(title: "Crew",
                                       dataProvider: StaticArrayDataProvider(models: movie.crew),
                                       animated: false)
        
        let castList = navCont?.visibleViewController
        XCTAssert(castList is ListViewController)
    }
    
    func test_Coordinator_Shows_UserProfile_IfLoggedIn() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(isLoggedIn: true)
        
        coordinator.showUserProfile(animated: false)
        
        let userProfile = navCont?.visibleViewController
        XCTAssert(userProfile is UserProfileViewController)
    }
    
    func test_Coordinator_Shows_UserLogin_IfNotLoggedIn() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(isLoggedIn: false)
        
        coordinator.showUserProfile(animated: false)
        
        let login = navCont?.visibleViewController
        XCTAssert(login is LoginViewController)
    }
}
