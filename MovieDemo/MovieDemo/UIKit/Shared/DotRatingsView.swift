//
//  DotRatingsView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

@IBDesignable
class DotRatingsView: UIView {
    
    let emptyCircle = UIImage(systemName: "circle")!
    let filledCircle = UIImage(systemName: "circle.fill")!
    let halfCircle = UIImage(systemName: "circle.lefthalf.fill")!
    let slashedCircle = UIImage(systemName: "slash.circle")!
    
    @IBInspectable
    var rating: Float = 0 {
        didSet {
            if rating > 10 {
                rating = 10
            }
            
            if rating < 0 {
                rating = 0
            }
            
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isRatingAvailable: Bool = true {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var spacing: Int = 3 {
        didSet { setNeedsDisplay() }
    }
     
    private func drawRatingImage(_ image: UIImage, position: Int, alpha: CGFloat = 1.0) {
        let itemSize = bounds.height
        
        let imageToDraw = image.withTintColor(.systemOrange)
        let rect = CGRect(x: (itemSize * CGFloat(position)) + CGFloat(spacing * position), y: 0, width: itemSize, height: itemSize)
        imageToDraw.draw(in: rect, blendMode: .normal, alpha: alpha)
    }

    override func draw(_ rect: CGRect) {        
        if !isRatingAvailable {
            for n in 0...4 {
                drawRatingImage(slashedCircle, position: n, alpha: 0.6)
            }
            
            return
        }
        
        let halfRating = rating / 2
        for n in 0...4 {
            if halfRating >= Float(n) + 0.9 {
                drawRatingImage(filledCircle, position: n)
            }
            else if halfRating >= Float(n) + 0.4, halfRating < Float(n) + 0.9  {
                drawRatingImage(halfCircle, position: n)
            } else {
                drawRatingImage(emptyCircle, position: n)
            }
        }
    }
    
    override func contentHuggingPriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        return .required
    }
    
    override func contentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        return .required
    }
    
    override var intrinsicContentSize: CGSize {
        let itemSize = bounds.height
        return CGSize(width: (itemSize  * 5) + CGFloat(spacing * 4), height: itemSize)
    }
    
}
