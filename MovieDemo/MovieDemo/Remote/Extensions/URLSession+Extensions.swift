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
    func validate(statusCode: Int) -> AnyPublisher<Data, Error> {
        validate(statusCode: statusCode...statusCode)
    }

    func validate(statusCode: any RangeExpression<Int> = 200..<300) -> AnyPublisher<Data, Error> {
        if let range = statusCode as? ClosedRange<Int> {
            Swift.print(range.lowerBound, range.upperBound)
        }
        
        return self
            .tryMap { output -> Data in
                if let response = output.response as? HTTPURLResponse {
                    if statusCode.contains(response.statusCode) { //Check Status Code is in validation range
                        return output.data
                    } else if response.statusCode == 401 { // Check for 401 if not in validation range
                        throw TMDBClient.ServiceError.IncorrectCredentials
                    } else { //Throw status code error
                        throw TMDBClient.ServiceError.StatusCodeError(code: response.statusCode)
                    }
                }
                
                throw TMDBClient.ServiceError.RequestError
            }
            .eraseToAnyPublisher()
    }
    
}
