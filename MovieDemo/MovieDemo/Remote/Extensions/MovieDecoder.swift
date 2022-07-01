//
//  MovieDecoder.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

class MovieDecoder: JSONDecoder {
    init(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) {
        super.init()
        self.keyDecodingStrategy = keyDecodingStrategy
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        self.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
}
