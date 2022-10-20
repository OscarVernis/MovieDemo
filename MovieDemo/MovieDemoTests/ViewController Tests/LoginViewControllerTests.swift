//
//  LoginViewControllerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class LoginViewControllerTests: XCTestCase {
    var sut: LoginViewController!
    var coordinator: MainCoordinator!
    let window = UIWindow()

    override func setUpWithError() throws {
        coordinator = MainCoordinator(window: window, isLoginRequired: true, usesWebLogin: false)
        coordinator.start()
        
        coordinator.showLogin(animated: false)
        let topVC = coordinator?.rootNavigationViewController?.visibleViewController
        let sut = topVC as? LoginViewController

        self.sut = try XCTUnwrap(sut, "Expected LoginViewController, " + "but was \(String(describing: topVC))")
    }
    
    override func tearDownWithError() throws {
        coordinator.rootNavigationViewController?.dismiss(animated: false)
        coordinator.rootNavigationViewController?.viewControllers = []
    
        sut = nil
        coordinator = nil
    }
    
    func test_deallocation() throws {
        assertDeallocation {
            let lvc = LoginViewController.instantiateFromStoryboard()
            lvc.loginViewModel = LoginViewModel(sessionManager: SessionManager.shared)
            
            return lvc
        }
    }
    
    func test_userTextField_attributesShouldBeSet() {
        sut.loadViewIfNeeded()

        let textField = sut.userTextField!
        XCTAssertEqual(textField.textContentType, .username)
        XCTAssertTrue(textField.enablesReturnKeyAutomatically)
    }
    
    func test_passwordTextField_attributesShouldBeSet() {
        sut.loadViewIfNeeded()

        let textField = sut.passwordTextField!
        XCTAssertEqual(textField.textContentType, .password)
        XCTAssertTrue(textField.isSecureTextEntry)
        XCTAssertTrue(textField.enablesReturnKeyAutomatically)
    }

    func test_emptyUsername_shouldDisableButton() {
        sut.loadViewIfNeeded()
        
        sut.userTextField.text = ""
        sut.passwordTextField.text = "password"
        
        sut.userTextField.sendActions(for: .editingChanged)
        sut.passwordTextField.sendActions(for: .editingChanged)

        XCTAssertEqual(sut.loginButton.isEnabled, false)
    }
    
    func test_emptyPassword_shouldDisableButton() {
        sut.loadViewIfNeeded()
        
        sut.userTextField.text = "username"
        sut.passwordTextField.text = ""
    
        sut.userTextField.sendActions(for: .editingChanged)
        sut.passwordTextField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(sut.loginButton.isEnabled, false)
    }
    
    func test_correctInput_shouldEnableButton() {
        sut.loadViewIfNeeded()
        
        sut.userTextField.text = "username"
        sut.passwordTextField.text = "password"
        
        sut.userTextField.sendActions(for: .editingChanged)
        sut.passwordTextField.sendActions(for: .editingChanged)
                
        XCTAssertEqual(sut.loginButton.isEnabled, true)
    }
    
    func test_returnOnUsername_shouldMoveFocusToPassword() {
        sut.loadViewIfNeeded()

        sut.userTextField.becomeFirstResponder()
        executeRunLoop()

        let _ = sut.userTextField.delegate?.textFieldShouldReturn?(sut.userTextField)
        
        XCTAssertTrue(sut.passwordTextField.isFirstResponder)
    }
    
    func test_returnOnPassword_shouldLogin() {
        let sessionService = SessionServiceMock()
        SessionManager.shared.store = UserStoreMock(isLoggedIn: false)
        SessionManager.shared.service = sessionService
        
        sut.loadViewIfNeeded()
        
        let exp = XCTestExpectation(description: "Login finishes")
        sut.didFinishLoginProcess = { exp.fulfill() }
        
        sut.userTextField.text = "username"
        sut.passwordTextField.text = "password"
        
        //Trigger validation publisher
        sut.passwordTextField.sendActions(for: .editingChanged)
        
        //Show keyboard on Password TextField
        sut.passwordTextField.becomeFirstResponder()
        executeRunLoop()
        
        //Simulate return on Password TextField
        let _ = sut.passwordTextField.delegate?.textFieldShouldReturn?(sut.passwordTextField)
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(sessionService.loginCount, 1)
        XCTAssertEqual(sessionService.username, "username")
        XCTAssertEqual(sessionService.password, "password")
    }
    
}
