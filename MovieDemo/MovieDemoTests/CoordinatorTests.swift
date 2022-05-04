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
        SessionManager.shared.userManager = LocalUserManager()
        navCont?.viewControllers = []
        window = nil
    }
    
    func test_Coordinator_Loads_Home() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let home = navCont?.visibleViewController
        XCTAssert(home is HomeCollectionViewController)
    }
    
    func test_Coordinator_Loads_Login() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: true)
        
        let sessionManager = SessionManager.shared
        sessionManager.userManager = UserManagerMock(isLoggedIn: false)
        
        coordinator.start()
        
        let login = navCont?.visibleViewController
        XCTAssert(login is LoginViewController)
    }
    
    func test_Coordinator_Shows_MovieDetail() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        coordinator.showMovieDetail(movie: anyMovie(), animated: false)
        
        let movieDetail = navCont?.visibleViewController
        XCTAssert(movieDetail is MovieDetailViewController)
    }
    
    func test_Coordinator_Shows_MovieList() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let movie = anyMovie()
        coordinator.showMovieList(title: "Movies",
                                  dataProvider: StaticArrayDataProvider(models: movie.recommendedMovies),
                                  animated: false)
        
        let movieList = navCont?.visibleViewController
        XCTAssert(movieList is ListViewController)
    }
    
    func test_Coordinator_Shows_PersonDetail() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        coordinator.showPersonProfile(anyPerson(), animated: false)
        
        let personDetail = navCont?.visibleViewController
        XCTAssert(personDetail is PersonDetailViewController)
    }
    
    func test_Coordinator_Shows_CastList() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let movie = anyMovie()
        coordinator.showCastCreditList(title: "Cast",
                                       dataProvider: StaticArrayDataProvider(models: movie.cast),
                                       animated: false)
        
        let castList = navCont?.visibleViewController
        XCTAssert(castList is ListViewController)
    }
    
    func test_Coordinator_Shows_CrewList() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let movie = anyMovie()
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
        sessionManager.userManager = UserManagerMock(isLoggedIn: true)
        
        coordinator.showUserProfile(animated: false)
        
        let userProfile = navCont?.visibleViewController
        XCTAssert(userProfile is UserProfileViewController)
    }
    
    func test_Coordinator_Shows_UserLogin_IfNotLoggedIn() throws {
        let coordinator = MainCoordinator(window: window, isLoginRequired: false)
        coordinator.start()
        
        let sessionManager = SessionManager.shared
        sessionManager.userManager = UserManagerMock(isLoggedIn: false)
        
        coordinator.showUserProfile(animated: false)
        
        let login = navCont?.visibleViewController
        XCTAssert(login is LoginViewController)
    }
}

//MARK: - Helpers
extension CoordinatorTests {
    func anyMovie() -> MovieViewModel {
        var movieData = Data()
        XCTAssertNoThrow( movieData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movie", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var movie = Movie()
        XCTAssertNoThrow( movie = try decoder.decode(Movie.self, from: movieData) )
        
        return MovieViewModel(movie: movie)
    }
    
    func anyPerson() -> PersonViewModel {
        var personData = Data()
        XCTAssertNoThrow( personData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Person", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var person = Person()
        XCTAssertNoThrow( person = try decoder.decode(Person.self, from: personData) )
        
        return PersonViewModel(person: person)
    }
}
