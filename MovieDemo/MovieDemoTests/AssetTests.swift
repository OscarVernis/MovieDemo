//
//  AssetTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 24/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class AssetTests: XCTestCase {

    func testImageAssetsExists() throws {
        let assets = ImageAsset.allCases
        
        for asset in assets {
            let image = asset.image
            XCTAssertNotNil(image)
        }
    }
    
    func testColorAssetsExists() throws {
        let assets = ColorAsset.allCases
        
        for asset in assets {
            let color = asset.color
            XCTAssertNotNil(color)
        }
    }
    
}

