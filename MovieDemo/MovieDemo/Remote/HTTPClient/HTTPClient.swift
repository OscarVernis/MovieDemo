//
//  HTTPClient.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

protocol HTTPClient {
    func requestPublisher(with: URL, body: (any Encodable)?, method: HTTPMethod) -> AnyPublisher<(DataTaskResult), Error>
}
