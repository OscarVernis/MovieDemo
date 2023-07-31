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
        
        let labelTextSize = (labelText as NSString)
            .boundingRect(with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
                          options: .usesLineFragmentOrigin,
                          attributes: [NSAttributedString.Key.font: font!],context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
    
    
    var numberOfLinesVisible : Int {
        if let text = text{
            // cast text to NSString so we can use sizeWithAttributes
            let myText = text as NSString
            
            //Set attributes
            let attributes = [NSAttributedString.Key.font : font!]
            
            //Calculate the size of your UILabel by using the systemfont and the paragraph we created before. Edit the font and replace it with yours if you use another
            let labelSize = myText.boundingRect(with: CGSize(width: bounds.width,height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            //Now we return the amount of lines using the ceil method
            let lines = ceil(CGFloat(labelSize.height) / font.lineHeight)
            return Int(lines)
        }
        
        return 0
    }
}
