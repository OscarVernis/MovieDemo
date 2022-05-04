//
//  SessionManagerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class SessionManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        SessionManager.shared.userManager = LocalUserManager()
        SessionManager.shared.service = RemoteLoginManager()
    }

    func test_login_success() throws {
        let sessionManager = SessionManager.shared
        sessionManager.userManager = UserManagerMock(isLoggedIn: false)
        sessionManager.service = LoginManagerMock()
        
        Task {
            let result = await sessionManager.login(withUsername:"username", password: "password")
            switch result {
            case .failure(_):
                XCTFail()
            default:
                XCTAssertEqual(sessionManager.isLoggedIn, true)
                XCTAssertEqual(sessionManager.username, "username")
                XCTAssertEqual(sessionManager.sessionId, "sessionId")
                break
            }

        }
    }
    
    func test_login_fails() throws {
        let sessionManager = SessionManager.shared
        sessionManager.userManager = UserManagerMock(isLoggedIn: false)
        sessionManager.service = LoginManagerMock(fails: true)
        
        Task {
            let result = await sessionManager.login(withUsername:"username", password: "password")
            switch result {
            case .failure(let error):
                XCTAssert(error is SessionManager.LoginError)
                XCTAssertEqual(error as! SessionManager.LoginError, SessionManager.LoginError.Default)
            default:
                XCTFail()
                break
            }

        }
    }
    
    func test_login_fails_on401() throws {
        let sessionManager = SessionManager.shared
        sessionManager.userManager = UserManagerMock(isLoggedIn: false)
        sessionManager.service = LoginManagerMock(fails: true, error: .IncorrectCredentials)
        
        Task {
            let result = await sessionManager.login(withUsername:"username", password: "password")
            switch result {
            case .failure(let error):
                XCTAssert(error is SessionManager.LoginError)
                XCTAssertEqual(error as! SessionManager.LoginError, SessionManager.LoginError.IncorrectCredentials)
            default:
                XCTFail()
                break
            }

        }
    }
    
    func test_logout_success() throws {
        let sessionManager = SessionManager.shared
        sessionManager.userManager = UserManagerMock(sessionId: "sessionid", username: "username", isLoggedIn: true)
        sessionManager.service = LoginManagerMock()
        
        Task {
            let result = await sessionManager.logout()
            switch result {
            case .failure(_):
                XCTFail()
            default:
                XCTAssertEqual(sessionManager.isLoggedIn, false)
                XCTAssertNil(sessionManager.username)
                XCTAssertNil(sessionManager.sessionId)
            }

        }
    }
    
    func test_logout_fails() throws {
        let sessionManager = SessionManager.shared
        sessionManager.userManager = UserManagerMock(sessionId: "sessionid", username: "username", isLoggedIn: true)
        sessionManager.service = LoginManagerMock(fails: true)
        
        Task {
            let result = await sessionManager.logout()
            switch result {
            case .failure(_):
                XCTAssertEqual(sessionManager.isLoggedIn, true)
                XCTAssertNotNil(sessionManager.username)
                XCTAssertNotNil(sessionManager.sessionId)
                break
            default:
                XCTFail()
            }
            
        }
    }
    
}

//MARK: - Mock

class LoginManagerMock: LoginManager {
    let fails: Bool
    let error: MovieService.ServiceError?
    
    init(fails: Bool = false, error: MovieService.ServiceError? = .ServiceError) {
        self.fails = fails
        self.error = error
    }
    
    func requestToken() async throws -> String {
        return "requestToken"
    }
    
    func validateToken(username: String, password: String, requestToken: String) async throws {
    }
    
    func createSession(requestToken: String) async throws -> String {
        if fails {
            if let error = error {
                throw error
            } else {
                throw MovieService.ServiceError.ServiceError
            }
        }
        
        return "sessionId"

    }
    
    func deleteSession(sessionId: String) async throws -> Result<Void, Error> {
        return fails ? .failure(MovieService.ServiceError.ServiceError) : .success(())
    }
    
    
}
