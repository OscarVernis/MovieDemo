//
//  CrewDepartment.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

enum CrewDepartment: String, Localizable, CaseIterable {
    case Acting
    case Sound
    case Production
    case Writing
    case CostumeMakeUp = "Costume & Make-Up"
    case Actors
    case Crew
    case VisualEffects = "Visual Effects"
    case Editing
    case Art
    case Lighting
    case Camera
    case Directing
    
    var tableName: String {
        "Department"
    }
}
