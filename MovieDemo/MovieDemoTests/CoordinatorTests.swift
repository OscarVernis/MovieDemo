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
        navCont?.viewControllers = []
        window = nil
    }
    
    func test_Coordinator_Loads_Home() throws {
        let sut = makeSUT(isLoginRequired: false)
        sut.start()
        
        let home = navCont?.visibleViewController
        XCTAssert(home is HomeViewController)
    }
    
    func test_Coordinator_Loads_Login() throws {
        let sut = makeSUT(isLoginRequired: true, isLoggedIn: false, usesWebLogin: false)
        
        sut.start()
        
        let login = navCont?.visibleViewController
        XCTAssert(login is LoginViewController)
    }
    
    func test_Coordinator_Loads_WebLogin() throws {
        let sut = makeSUT(isLoginRequired: true, isLoggedIn: false, usesWebLogin: true)
        
        sut.start()
        
        let login = navCont?.visibleViewController
        XCTAssert(login is WebLoginViewController)
    }
    
    func test_Coordinator_Shows_MovieDetail() throws {
        let sut = makeSUT(isLoginRequired: false)
        sut.start()
        
        sut.showMovieDetail(movie: anyMovieVM(), animated: false)
        
        let movieDetail = navCont?.visibleViewController
        XCTAssert(movieDetail is MovieDetailViewController)
    }
    
    func test_Coordinator_Shows_MovieList() throws {
        let sut = makeSUT(isLoginRequired: false)
        sut.start()
        
        let movie = anyMovieVM()
        sut.showMovieList(title: "Movies",
                                  dataProvider: BasicProvider(models: movie.recommendedMovies),
                                  animated: false)
        
        let movieList = navCont?.visibleViewController
        XCTAssert(movieList is ListViewController<BasicProvider<MovieViewModel>, MovieInfoListCell>, "Expected ListViewController, " + "but was \(String(describing: movieList))")
    }
    
    func test_Coordinator_Shows_PersonDetail() throws {
        let sut = makeSUT(isLoginRequired: false)
        sut.start()
        
        sut.showPersonProfile(anyPersonVM(), animated: false)
        
        let personDetail = navCont?.visibleViewController
        XCTAssert(personDetail is PersonDetailViewController)
    }
    
    func test_Coordinator_Shows_CastList() throws {
        let sut = makeSUT(isLoginRequired: false)
        sut.start()
        
        let movie = anyMovieVM()
        sut.showCastCreditList(credits: movie.cast,
                                       animated: false)
        
        let castList = navCont?.visibleViewController
        XCTAssert(castList is ListViewController<BasicProvider<CastCreditViewModel>, CreditPhotoListCell>)
    }
    
    func test_Coordinator_Shows_CrewList() throws {
        let sut = makeSUT(isLoginRequired: false)
        sut.start()
        
        let movie = anyMovieVM()
        sut.showCrewCreditList(credits: movie.crew,
                                       animated: false)
        
        let castList = navCont?.visibleViewController
        XCTAssert(castList is ListViewController<BasicProvider<CrewCreditViewModel>, CreditPhotoListCell>)
    }
    
    func test_Coordinator_Shows_UserProfile_IfLoggedIn() throws {
        let sut = makeSUT(isLoginRequired: false, isLoggedIn: true, usesWebLogin: false)
        sut.start()
        
        sut.showUserProfile(animated: false)
        
        let userProfile = navCont?.visibleViewController
        XCTAssert(userProfile is UserProfileViewController)
    }
    
    func test_Coordinator_Shows_UserLogin_IfNotLoggedIn() throws {
        let sut = makeSUT(isLoginRequired: false, isLoggedIn: false, usesWebLogin: false)
        sut.start()
        
        sut.showUserProfile(animated: false)
        
        let login = navCont?.visibleViewController
        XCTAssert(login is LoginViewController)
    }
    
    func test_Coordinator_Shows_WebLogin_IfNotLoggedIn() throws {
        let sut = makeSUT(isLoginRequired: false, isLoggedIn: false, usesWebLogin: true)

        sut.start()
        
        sut.showUserProfile(animated: false)
        
        let login = navCont?.visibleViewController
        XCTAssert(login is WebLoginViewController)
    }
    
    fileprivate func makeSUT(isLoginRequired: Bool = false, isLoggedIn: Bool = false, usesWebLogin: Bool = false) -> MainCoordinator {
        let service = SessionServiceMock()
        let store = UserStoreMock(isLoggedIn: isLoggedIn)
        let sessionManager = SessionManager(service: service, store: store)
        let dependencies = AppDependencyContainer(sessionManager: sessionManager)
        return MainCoordinator(window: window, isLoginRequired: isLoginRequired, usesWebLogin: usesWebLogin, dependencyContainer: dependencies)
    }
}
