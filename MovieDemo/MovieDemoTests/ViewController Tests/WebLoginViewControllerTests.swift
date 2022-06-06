//
//  WebLoginViewControllerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class WebLoginViewControllerTests: XCTestCase {

    func test_deallocation() throws {
        assertDeallocation {
            WebLoginViewController.instantiateFromStoryboard()
        }
    }

}
