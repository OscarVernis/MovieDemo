//
//  RestClient.swift
//  test
//
//  Created by Oscar Vernis on 7/9/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import Foundation

enum RestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum RestEncoding {
    case NoEncoding
    case JSONEncoding
    case URLEncoding
    case FormEncoding
}

enum RestRequestError: Error {
    case invalidParameters
}

extension RestRequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidParameters:
            return NSLocalizedString("Invalid URL parameters.", comment: "Invalid Parameter")
        }
    }
}

struct RestResponse {
    var headers: [AnyHashable: Any]?
    var body: Data? {
        didSet {
            if let data = body {
                var json: Any
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: [])
                } catch {
                    isJSON = false
                    self.error = error
                    
                    return
                }
                
                isJSON = true
                jsonRepresentation = json
                
            } else {
                isJSON = false
            }
        }
    }
    
    var error: Error?
    var statusCode: Int = 0
    
    var bodyString: String? {
        guard let data = body else {
            return nil
        }
        
        return String(data: data, encoding: .ascii)
    }
    
    var isJSON: Bool = false
    var jsonRepresentation: Any?
}

struct RestClient {
    static var logging = false
    
    static func url(_ urlString: String, withParameters params: [String: String]) -> String? {
        var urlComponents = URLComponents(string: urlString)
        var queryItems = [URLQueryItem]()
        for component in params {
            let queryItem = URLQueryItem(name: component.key, value:component.value)
            queryItems.append(queryItem)
        }
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url?.absoluteString
    }
    
    //MARK: - Request
    
    static func request(_ urlString: String, method: RestMethod = .get, body: Data? = nil, encoding: RestEncoding = .NoEncoding, headers: [String: String]? = nil, completionHandler: @escaping (RestResponse) -> ()) {
        
        let url = URL(string: urlString)!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        switch encoding {
   
        case .NoEncoding, .URLEncoding:
            break
        case .JSONEncoding:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .FormEncoding:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = body

        if let headers = headers {
            for header in headers {
                request.addValue(header.key, forHTTPHeaderField: header.value)
            }
        }
        
        session.dataTask(with: request) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            
            DispatchQueue.main.async {
                var restResponse = RestResponse(statusCode: httpResponse.statusCode)
                restResponse.body = data
                restResponse.error = error
                restResponse.headers = httpResponse.allHeaderFields
                
                completionHandler(restResponse)
            }
            
            if logging {
                print("//////////////////////////////////////////////////////////////////")
                print("     URL: \(urlString)")
                print("    BODY: \((String(data: body ?? Data(), encoding: .utf8) ?? ""))")
//                print(" HEADERS: \(httpResponse.allHeaderFields)")
                print("  METHOD: \(request.httpMethod ?? "")")
                print("  STATUS: \(httpResponse.statusCode)")
                print("RESPONSE: \(String(data: data!, encoding: .utf8) ?? "")")
                print("//////////////////////////////////////////////////////////////////");
            }
        }.resume()
    }
    
    static func request(_ urlString: String, method: RestMethod = .get, parameters: Any, encoding: RestEncoding = .JSONEncoding, headers: [String: String]? = nil, completionHandler: @escaping (RestResponse) -> ()) {
        
        var body = Data()
        var url = urlString
        
        switch encoding {
        case .JSONEncoding:
            if JSONSerialization.isValidJSONObject(parameters) {
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    body = data
                } catch {
                    var errorResponse = RestResponse()
                    errorResponse.error = error
                    completionHandler(errorResponse)
                    
                    return
                }
            } else {
                var errorResponse = RestResponse()
                errorResponse.error = RestRequestError.invalidParameters
                completionHandler(errorResponse)
                
                return
            }
            
        case .URLEncoding:
            if let components = parameters as? [String: String] {
                if let urlStringWithComponents = RestClient.url(url, withParameters: components) {
                    url = urlStringWithComponents
                } else {
                    var errorResponse = RestResponse()
                    errorResponse.error = RestRequestError.invalidParameters
                    completionHandler(errorResponse)
                    
                    return
                }
            } else {
                var errorResponse = RestResponse()
                errorResponse.error = RestRequestError.invalidParameters
                completionHandler(errorResponse)

                return
            }
            
        case .FormEncoding:
            var paramString = String()
            if let components = parameters as? [String: String] {
                for (key, value) in components {
                    if let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        paramString += "\(escapedKey)=\(escapedValue)&"
                    }
                }
                
                if !paramString.isEmpty {
                    body = paramString.data(using: .utf8) ?? Data()
                } else {
                    var errorResponse = RestResponse()
                    errorResponse.error = RestRequestError.invalidParameters
                    completionHandler(errorResponse)
                }
            } else {
                var errorResponse = RestResponse()
                errorResponse.error = RestRequestError.invalidParameters
                completionHandler(errorResponse)
            }
        case .NoEncoding:
            break
        }
        
        RestClient.request(url, method: method, body: body, encoding: encoding, headers: headers, completionHandler: completionHandler)
        
    }
    
    //MARK: - Convenience
    
    static func get(_ urlString: String, urlParameters: [String: String]? = nil, headers: [String: String]? = nil, completionHandler: @escaping (RestResponse) -> ()) {
        if urlParameters == nil {
            RestClient.request(urlString, completionHandler: completionHandler)
        } else {
            RestClient.request(urlString, parameters: urlParameters as Any, encoding: .URLEncoding, completionHandler: completionHandler)
        }
    }
    
    static func post(_ urlString: String, parameters: Any, encoding: RestEncoding = .JSONEncoding, headers: [String: String]? = nil, completionHandler: @escaping (RestResponse) -> ()) {
        RestClient.request(urlString, method: .post, parameters: parameters, encoding: encoding, headers: headers, completionHandler: completionHandler)
    }
    
}
