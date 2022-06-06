//
//  SessionStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

protocol SessionStore {
    var sessionId: String? { get }

    func save(sessionId: String)
    func delete()
}
