//
//  UserListsRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol UserListsRouter: ErrorHandlingRouter {
    func showUserListDetail(list: UserList, animated: Bool)
}

extension UserListsRouter {
    func showUserListDetail(list: UserList, animated: Bool = true) {
        showUserListDetail(list: list, animated: animated)
    }

}
