//
//  ProgressLayer.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 24/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class ProgressLayer: CALayer {
    @NSManaged var rating: CGFloat
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? ProgressLayer {
            rating = layer.rating
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private class func isCustomAnimKey(key: String) -> Bool {
        return key == "rating"
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if self.isCustomAnimKey(key: key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        if ProgressLayer.isCustomAnimKey(key: event) {
            if let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation {
                animation.keyPath = event
                if let pLayer = presentation() {
                    animation.fromValue = pLayer.rating
                }
                animation.toValue = nil
                return animation
            }
            setNeedsDisplay()
            return nil
        }
        return super.action(forKey: event)
    }
}
