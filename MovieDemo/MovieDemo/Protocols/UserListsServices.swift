//
//  UserListsServices.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

typealias UserListsResult = (movies: [UserList], totalPages: Int)

typealias UserListsService = (_ page: Int) -> UserListsResult
