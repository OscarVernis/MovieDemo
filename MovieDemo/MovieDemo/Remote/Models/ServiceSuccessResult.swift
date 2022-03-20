//
//  ServiceSuccess.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 19/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct ServiceSuccessResult: Codable {
    var success: Bool?
    var sessionId: String?
    var requestToken: String?
}
