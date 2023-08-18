//
//  WatchProviderViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

enum WatchProviderType: Hashable {
    case streaming
    case buy
    case rent
    
    var localizedString: String {
        switch self {
        case .streaming:
            return WatchProviderString.Streaming.localized
        case .buy:
            return WatchProviderString.Buy.localized
        case .rent:
            return WatchProviderString.Rent.localized
        }
    }
}

struct WatchProviderViewModel: Identifiable {
    let id: Int
    let name: String
    let logoURL: URL?
    let displayPriority: Int
    let serviceTypes: [WatchProviderType]
    
    var servicesString: String {
        serviceTypes.map({ $0.localizedString.uppercased() }).joined(separator: ", ")
    }
}
