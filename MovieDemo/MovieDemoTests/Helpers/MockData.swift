//
//  MockData.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Mocker
import Alamofire

class MockData {
    var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        
        return Alamofire.Session(configuration: configuration)
    }()
    
    init(data: Data, url: URL, statusCode: Int = 200) {
        let mock = Mock(url: url, ignoreQuery: true, dataType: .json, statusCode: statusCode, data: [
            .get : data
        ])
        mock.register()
    }
    
    convenience init (jsonFile: String, url: URL, statusCode: Int = 200) {
        let mockedData = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: jsonFile, withExtension: "json")!)
        self.init(data: mockedData, url: url, statusCode: statusCode)
    }
    
    convenience init<T: Encodable>(jsonObject: T, url: URL, statusCode: Int = 200) {
        let mockedData = try! JSONEncoder().encode(jsonObject)
        self.init(data: mockedData, url: url, statusCode: statusCode)
    }
}
