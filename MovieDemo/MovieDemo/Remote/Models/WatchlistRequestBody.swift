//
//  WatchlistRequestBody.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct WatchlistRequestBody: Encodable {
    var media_type: String = "movie"
    var media_id: Int
    var watchlist: Bool
}
