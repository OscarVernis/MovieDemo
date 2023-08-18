//
//  WatchProviderString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

enum WatchProviderString: String, Localizable, CaseIterable {
    case AvailableOn
    case WhereAreYouWatching
    case WhereToWatch
    case ProvidedBy
    case Streaming
    case Buy
    case Rent
    case And
    
    var tableName: String { "WatchProviders" }
}
