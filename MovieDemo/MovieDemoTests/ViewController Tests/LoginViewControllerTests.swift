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

    override func setUpWithError() throws {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        coordinator = appDelegate?.appCoordinator
        
        coordinator?.showLogin(animated: false)
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
            LoginViewController.instantiateFromStoryboard()
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
        let loginManagerMock = LoginManagerMock()
        SessionManager.shared.userManager = UserManagerMock(isLoggedIn: false)
        SessionManager.shared.service = loginManagerMock
        
        sut.loadViewIfNeeded()
        
        let exp = XCTestExpectation(description: "Login finishes")
        sut.didFinishLoginProcess = { exp.fulfill() }
        
        sut.userTextField.text = "username"
        sut.passwordTextField.text = "password"
        
        sut.passwordTextField.becomeFirstResponder()
        executeRunLoop()
        
        let _ = sut.passwordTextField.delegate?.textFieldShouldReturn?(sut.passwordTextField)
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(loginManagerMock.loginCount, 1)
        XCTAssertEqual(loginManagerMock.username, "username")
        XCTAssertEqual(loginManagerMock.password, "password")
    }
    
}

