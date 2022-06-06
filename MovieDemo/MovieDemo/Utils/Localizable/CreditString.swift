//
//  CreditString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum CreditString: String, Localizable, CaseIterable {
    case Director
    case Writer
    case Story
    case Screenplay
    case Cinematography
    case Music
    case Editor
    case Characters
    
    var localized: String { NSLocalizedString(rawValue, comment: "") }
}
