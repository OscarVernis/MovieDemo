//
//  URLSessionHTTPClient.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class URLSessionHTTPClient: HTTPClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestPublisher(with url: URL, body: (any Encodable)?, method: HTTPMethod) -> AnyPublisher<(DataTaskResult), Error> {
        let urlRequest = request(for: url, method: method, payload: body)
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .mapError { urlerror in
                urlerror as Error
            }
            .eraseToAnyPublisher()
    }

    private func request(for url: URL, method: HTTPMethod, payload: (any Encodable)? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let payload = payload {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let codedBody: Data? = try? JSONEncoder().encode(payload)
            request.httpBody = codedBody
        }
        
        return request
    }
    
}
