//
//  PersonCastCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonCastCreditViewModel: MovieViewModel {
    private weak var castCredit: PersonCastCredit!

    init(personCastCredit: PersonCastCredit) {
        self.castCredit = personCastCredit
        super.init(movie: personCastCredit)
    }
    
    var character: String? {
        return castCredit.character
    }
    
    var attributedCreditString: NSAttributedString {
        let creditString = NSMutableAttributedString()

        var attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont(name: "Avenir-Heavy", size: 16)!,
            .foregroundColor : UIColor.label
        ]
        let titleString = NSAttributedString(string: castCredit.title, attributes: attributes)
        creditString.append(titleString)
        
        guard let character = character, !character.isEmpty else {
            return titleString
        }
        
        attributes = [
            .font : UIFont(name: "Avenir-Book", size: 16)!,
            .foregroundColor : UIColor.tertiaryLabel
        ]
        let asString = NSAttributedString(string: NSLocalizedString(" as ", comment: ""), attributes: attributes)
        creditString.append(asString)
        
        attributes = [
            .font : UIFont(name: "Avenir-Medium", size: 16)!,
            .foregroundColor : UIColor.secondaryLabel
        ]
        let characterString = NSAttributedString(string: character, attributes: attributes)
        creditString.append(characterString)
        
        return creditString
    }
    
    var year: String {
        let dateFormatter = DateFormatter(withFormat: "yyyy", locale: Locale.current.identifier)
        
        return castCredit.releaseDate != nil ? dateFormatter.string(from: castCredit.releaseDate!) : "-"
    }
    
}
