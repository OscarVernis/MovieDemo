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
        let stringCases = CreditString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    func test_ErrorStrings() throws {
        let stringCases = ErrorString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    func test_GenreStrings() throws {
        let stringCases = GenreString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    func test_HomeStrings() throws {
        let stringCases = HomeString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    func test_MovieStrings() throws {
        let stringCases = MovieString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    func test_PersonStrings() throws {
        let stringCases = PersonString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    
    func test_ServiceStrings() throws {
        let stringCases = ServiceString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    func test_UserStrings() throws {
        let stringCases = UserString.allCases.map(\.rawValue)
        assertLocalizedStrings(stringCases)
    }
    
    //MARK: - Helper
    func assertLocalizedStrings(_ strings: [String]) {
        let testValue = "test-value"
        
        for string in strings {
            let localizedString = NSLocalizedString(string, value: testValue, comment: "")
            
            //NSLocalizedString() returns 'value' if the key is not found.
            XCTAssertNotEqual(localizedString, testValue, "\(string) not found!")
        }
    }

}
