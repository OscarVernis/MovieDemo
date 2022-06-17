//
//  JSONUserLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct JSONUserLoader: UserLoader {
    let user: User
    var jsonDecoder = MovieService().jsonDecoder()
    
    init(filename: String) {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: filename, withExtension: "json")!)
            user = try jsonDecoder.decode(User.self, from: data)
        } catch {
            fatalError("Couldn't load \(filename).json")
        }
    }
    
    func getUserDetails() -> AnyPublisher<User, Error> {
        Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
