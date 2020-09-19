//
//  RatingsView.swift
//  Ratings
//
//  Created by Oscar Vernis on 18/09/20.
//

import UIKit


@IBDesignable
class RatingsView: UIView {
    enum Style: Int {
        case circle
        case line
    }
    
    var style : Style = .circle

    @IBInspectable
    var styleInt: Int {
        get {
            style.rawValue
        }
        set(value) {
            if let newStyle = Style(rawValue: value) {
                style = newStyle
            }
        }
    }
        
    @IBInspectable
    var rating: UInt = 0 {
        didSet {
            if rating > 100 {
                rating = 100
            }
            
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isRatingAvailable: Bool = true {
        didSet {
            if isRatingAvailable == false {
                rating = 0
            }
            
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 3 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var lineSpacing: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }
    
    private let greenRatingColor = #colorLiteral(red: 0.1294117647, green: 0.8156862745, blue: 0.4784313725, alpha: 1)
    private let greenTrackColor = #colorLiteral(red: 0.06365625043, green: 0.4012272754, blue: 0.2353352288, alpha: 0.6956208882)
    private let yellowRatingColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1)
    private let yellowTrackColor = #colorLiteral(red: 0.4769007564, green: 0.3958523571, blue: 0.01167693827, alpha: 0.6986019737)
    private let redRatingColor = #colorLiteral(red: 0.8588235294, green: 0.137254902, blue: 0.3764705882, alpha: 1)
    private let redTrackColor = #colorLiteral(red: 0.4028055548, green: 0.06437531699, blue: 0.176572298, alpha: 0.7033599624)
    private let grayTrackColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.5032307331)
        
    override func draw(_ rect: CGRect) {
        var trackColor: UIColor!
        var ratingColor: UIColor!
        
        switch rating {
        case 0...40:
            trackColor = redTrackColor
            ratingColor = redRatingColor
        case 41...70:
            trackColor = yellowTrackColor
            ratingColor = yellowRatingColor
        case 71...100:
            trackColor = greenTrackColor
            ratingColor = greenRatingColor
        default:
            trackColor = greenTrackColor
            ratingColor = greenRatingColor
        }
        
        if isRatingAvailable == false {
            trackColor = grayTrackColor
        }
        
        switch style {
        case .circle:
            drawCircleRating(trackColor: trackColor, ratingColor: ratingColor)
        case .line:
            drawLineRating(trackColor: trackColor, ratingColor: ratingColor)
        }
        
       
    }
    
    private func drawLineRating(trackColor: UIColor, ratingColor: UIColor) {
        //Round linecap is drawn outside the line, so we calculate the padding
        let padding = bounds.height / 2
        let lineWidth = bounds.height

        let startPoint = CGPoint(x: padding, y: bounds.midY)
        let endPoint = CGPoint(x: (bounds.maxX - padding), y: bounds.midY)
        
        let ratingX = (bounds.maxX - (padding * 2)) * (CGFloat(rating) / 100) + padding
        let ratingEndPoint = CGPoint(x: ratingX, y: bounds.midY)
        
        //Draw track
        let trackPath = UIBezierPath()
        trackPath.move(to: startPoint)
        trackPath.addLine(to: endPoint)
        trackPath.lineWidth = lineWidth
        trackPath.lineCapStyle = .round
        trackColor.set()
        trackPath.stroke()
        
        //Don't draw rating if there isn't one or is 0
        if isRatingAvailable == false || rating == 0 {
            return
        }
        
        //Draw ratings line
        let ratingPath = UIBezierPath()
        ratingPath.move(to: startPoint)
        ratingPath.addLine(to: ratingEndPoint)
        ratingPath.lineWidth = lineWidth
        ratingPath.lineCapStyle = .round
        ratingColor.set()
        ratingPath.stroke()
    }
    
    private func drawCircleRating(trackColor: UIColor, ratingColor: UIColor) {
        let size = bounds.height
        let radius = size / 2
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        let ratingDegree = 3.6 * Double(rating)
        let startAngle = deg2rad(270)
        let endAngle = deg2rad(ratingDegree+270)
        
        //Draw track circle
        let trackPath = UIBezierPath(ovalIn: rect.inset(by: UIEdgeInsets(top: lineSpacing, left: lineSpacing, bottom: lineSpacing, right: lineSpacing)))
        trackPath.lineWidth = lineWidth
        trackColor.set()
        trackPath.stroke()
        
        //Don't draw rating if there isn't one or is 0
        if !isRatingAvailable || rating == 0 {
            return
        }
                
        //Draw rating arc
        let ratingPath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: (radius - lineSpacing), startAngle: startAngle, endAngle:endAngle, clockwise: true)
        ratingPath.lineWidth = lineWidth
        ratingPath.lineCapStyle = .round
        ratingColor.set()
        ratingPath.stroke()
    }
    
    private func deg2rad(_ number: Double) -> CGFloat {
        return CGFloat(number * .pi / 180)
    }
    
    override var intrinsicContentSize: CGSize {
        if style == .circle {
            return CGSize(width: bounds.height, height: bounds.height)
        }
        else {
            return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        }
    }
    
}
