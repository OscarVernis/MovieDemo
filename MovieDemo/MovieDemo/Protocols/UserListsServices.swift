//
//  UserListsServices.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias UserListsResult = (lists: [UserList], totalPages: Int)

typealias UserListsService = (_ page: Int) -> AnyPublisher<UserListsResult, Error>

protocol UserListActionsService {
    func createList(name: String, description: String) async throws -> UserList

    func delete(listId: Int) async throws
}
