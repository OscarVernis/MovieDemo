//
//  URLSession+Extensions.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias DataTaskResult = (data: Data, response: URLResponse)

extension Publisher where Output == DataTaskResult {
    func validate(statusCode: Range<Int> = 200..<300) -> AnyPublisher<Data, Error> {
        return self
            .tryMap { output -> Data in
                if let response = output.response as? HTTPURLResponse {
                    if statusCode.contains(response.statusCode) { //Check Status Code is in validation range
                        return output.data
                    } else if response.statusCode == 401 { // Check for 401 if not in validation range
                        throw MovieService.ServiceError.IncorrectCredentials
                    } else { //Throw status code error
                        throw MovieService.ServiceError.StatusCodeError(code: response.statusCode)
                    }
                }
                
                throw MovieService.ServiceError.RequestError
            }
            .eraseToAnyPublisher()
    }
    
}
