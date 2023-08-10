//
//  PersonDetailViewControllerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class PersonDetailViewControllerTests: XCTestCase {

    func test_deallocation() throws {
        assertDeallocation {
            let pvc = PersonDetailViewController()
            pvc.store = PersonDetailStore(person: anyPersonVM())
            
            return pvc
        }
    }

}
