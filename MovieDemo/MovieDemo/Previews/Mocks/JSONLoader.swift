//
//  JSONLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct JSONLoader<Model: Decodable> {
    var model: Model? = nil
    var jsonDecoder = MovieDecoder()
    
    private var error: Error?

    init(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            error = NSError(domain: "Wrong filename!", code: 0)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            model = try jsonDecoder.decode(Model.self, from: data)
        } catch let jsonError {
            error = jsonError
        }
    }
    
    func publisher() -> AnyPublisher<Model, Error> {
        if let error = error {
            return Fail(outputType: Model.self, failure: error)
                .eraseToAnyPublisher()
        }
        
        if let model {
            return Just(model)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Empty<Model, Error>(completeImmediately: true)
                .eraseToAnyPublisher()
        }
    }
    
}
