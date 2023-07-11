//
//  JSONUserLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct JSONUserLoader {
    var user: User = User()
    var jsonDecoder = MovieDecoder()
    
    private var error: Error?
    
    init(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            error = NSError(domain: "Wrong filename!", code: 0)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            user = try jsonDecoder.decode(User.self, from: data)
        } catch let jsonError {
            error = jsonError
        }
    }
    
    func getUserDetails() -> AnyPublisher<User, Error> {
        if let error = error {
            return Fail(outputType: User.self, failure: error)
                .eraseToAnyPublisher()
        }
        
        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
