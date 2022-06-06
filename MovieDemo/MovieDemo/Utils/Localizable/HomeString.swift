//
//  HomeString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum HomeString: String, Localizable, CaseIterable {
    case Movies
    case NowPlaying
    case Popular
    case TopRated
    case Upcoming

    var tableName: String { "Home" }
}
