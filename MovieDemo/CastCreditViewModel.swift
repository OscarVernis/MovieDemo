//
//  CastCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class CastCreditViewModel {
    let castCredit: CastCredit
        
    init(castCredit: CastCredit) {
        self.castCredit = castCredit
    }
    
}

extension CastCreditViewModel {
    var name: String {
        castCredit.name
    }
    
    var character: String {
        castCredit.character ?? ""
    }
    
    var profileImageURL: URL? {
        guard let pathString = castCredit.profilePath else { return nil }
        
        return MovieDBService.profileImageURL(forPath: pathString, size: .h632)
    }
}
