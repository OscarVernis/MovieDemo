//
//  ServiceString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum ServiceString: String, Localizable, CaseIterable {
    case ServiceLocale
    
    var tableName: String { "Service" }
}
