//
//  Date+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 31/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension Date {
    func distanceInYears(to toDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self, to: toDate)
        
        return components.year!
    }
    
}
