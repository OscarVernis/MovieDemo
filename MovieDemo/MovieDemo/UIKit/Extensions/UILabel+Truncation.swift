//
//  UILabel+Truncation.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = labelText
            .boundingRect(with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                          attributes: [NSAttributedString.Key.font: font!],
                          context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
    
}
