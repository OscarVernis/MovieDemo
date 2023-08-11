//
//  NumberClamping.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension FloatingPoint {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(min(self, range.upperBound), range.lowerBound)
    }
}


extension BinaryInteger {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(min(self, range.upperBound), range.lowerBound)
    }
}
