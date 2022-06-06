//
//  Localizable.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String {
    static func localized(_ localizedString: Localizable) -> String {
        return localizedString.localized
    }
    
}
