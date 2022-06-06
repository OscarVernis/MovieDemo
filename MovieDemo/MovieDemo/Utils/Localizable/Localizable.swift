//
//  Localizable.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

protocol Localizable {
    var localized: String { get }
    var tableName: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {    
    var localized: String { NSLocalizedString(rawValue, tableName: tableName, comment: "") }
}

extension String {
    static func localized(_ localizedString: Localizable) -> String {
        return localizedString.localized
    }
    
}

