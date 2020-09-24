//
//  Double+Math.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 24/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import CoreGraphics

extension Double {
    func toRadians() -> Double {
        return (self * Double.pi / 180)
    }
    
    func toDegrees() -> Double {
        return (self * 180 / Double.pi)
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return (self * CGFloat.pi / 180)
    }
    
    func toDegrees() -> CGFloat {
        return (self * 180 / CGFloat.pi)
    }
}
