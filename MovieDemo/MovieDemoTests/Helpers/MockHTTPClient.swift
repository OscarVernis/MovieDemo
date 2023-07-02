//
//  MockHTTPClient.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 01/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine
@testable import MovieDemo

class MockHTTPClient: HTTPClient {
    private var publisher: AnyPublisher<(DataTaskResult), Error>
    
    init(data: Data, url: URL, statusCode: Int = 200) {
        let response: URLResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        self.publisher = Just(DataTaskResult(data: data, response: response))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
    }
    
    convenience init (jsonFile: String, url: URL, statusCode: Int = 200) {
        let mockedData = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: jsonFile, withExtension: "json")!)
        self.init(data: mockedData, url: url, statusCode: statusCode)
    }
    
    convenience init<T: Encodable>(jsonObject: T, url: URL, statusCode: Int = 200) {
        let mockedData = try! JSONEncoder().encode(jsonObject)
        self.init(data: mockedData, url: url, statusCode: statusCode)
    }
    
    func requestPublisher(with url: URL, body: (any Encodable)?, method: HTTPMethod) -> AnyPublisher<(DataTaskResult), Error> {
        publisher
    }
    
}
