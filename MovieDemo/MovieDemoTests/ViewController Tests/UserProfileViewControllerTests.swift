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
            let store = MockData.userProfileStore
            return UserProfileViewController(store: store)
        }
    }

    func test_store_deallocation() throws {
        let service = MockData.userMock.publisher
        let store = UserProfileStore(service: service)
        store.updateUser()
        trackForMemoryLeaks(store)
    }
}
