//
//  UserProfileViewControllerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class UserProfileViewControllerTests: XCTestCase {

    func test_deallocation() throws {
        assertDeallocation {
            UserProfileViewController()
        }
    }

}