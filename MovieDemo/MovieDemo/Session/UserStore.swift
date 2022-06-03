//
//  UserStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

protocol UserStore {
    var sessionId: String? { get }
    var username: String? { get }

    func save(username: String, sessionId: String)
    func delete()
}
