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
            let service = JSONUserLoader(filename: "user").getUserDetails()
            let store = UserProfileStore(service: service)
            return UserProfileViewController(store: UserProfileStore(service: service))
        }
    }

    func test_store_deallocation() throws {
        let service = JSONUserLoader(filename: "user").getUserDetails()
        let store = UserProfileStore(service: service)
        store.updateUser()
        trackForMemoryLeaks(store)
    }
}
