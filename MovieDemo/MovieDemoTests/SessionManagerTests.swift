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

    func test_login_success() async throws {
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(isLoggedIn: false)
        sessionManager.service = SessionServiceMock()
        
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
    
    func test_login_fails() async throws {
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(isLoggedIn: false)
        sessionManager.service = SessionServiceMock(fails: true)
        
        let result = await sessionManager.login(withUsername:"username", password: "password")
        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? SessionManager.LoginError, SessionManager.LoginError.Default)
        default:
            XCTFail()
            break
        }
        
    }
    
    func test_login_fails_on401() async throws {
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(isLoggedIn: false)
        sessionManager.service = SessionServiceMock(fails: true, error: .IncorrectCredentials)
        
        let result = await sessionManager.login(withUsername:"username", password: "password")
        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? SessionManager.LoginError, SessionManager.LoginError.IncorrectCredentials)
        default:
            XCTFail()
            break
        }
        
    }
    
    func test_logout_success() async throws {
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(sessionId: "sessionid", username: "username")
        sessionManager.service = SessionServiceMock()
        
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
    
    func test_logout_fails() async throws {
        let sessionManager = SessionManager.shared
        sessionManager.store = UserStoreMock(sessionId: "sessionid", username: "username")
        sessionManager.service = SessionServiceMock(fails: true)
        
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
