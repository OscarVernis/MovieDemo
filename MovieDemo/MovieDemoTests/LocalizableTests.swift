//
//  LocalizableTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class LocalizableTests: XCTestCase {
    
    func test_CreditStrings() throws {
        assertLocalizedStrings(CreditString.self)
    }
    
    func test_ErrorStrings() throws {
        assertLocalizedStrings(ErrorString.self)
    }
    
    func test_GenreStrings() throws {
        assertLocalizedStrings(GenreString.self)
    }
    
    func test_HomeStrings() throws {
        assertLocalizedStrings(HomeString.self)
    }
    
    func test_MovieStrings() throws {
        assertLocalizedStrings(MovieString.self)
    }
    
    func test_PersonStrings() throws {
        assertLocalizedStrings(PersonString.self)
    }
    
    
    func test_ServiceStrings() throws {
        assertLocalizedStrings(ServiceString.self)
    }
    
    func test_UserStrings() throws {
        assertLocalizedStrings(UserString.self)
    }
    
    //MARK: - Helper
    func assertLocalizedStrings<T: CaseIterable & RawRepresentable>(_ type: T.Type) where T.RawValue == String {
        let testValue = "test-value"
        let stringCases = T.allCases.map(\.rawValue)
        
        for string in stringCases {
            let localizedString = NSLocalizedString(string, value: testValue, comment: "")
            
            //NSLocalizedString() returns 'value' if the key is not found.
            XCTAssertNotEqual(localizedString, testValue, "\(string) not found!")
        }
    }

}
