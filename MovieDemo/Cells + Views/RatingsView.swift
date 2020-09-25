//
//  RatingsView.swift
//  Ratings
//
//  Created by Oscar Vernis on 18/09/20.
//

import UIKit


@IBDesignable
class RatingsView: UIControl {
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
    @objc dynamic var rating: CGFloat {
        set {
            progressLayer.rating = newValue
            setNeedsDisplay()
        }
        get {
            return progressLayer.rating
        }
    }
    
    private (set) var value: Float = 0
    
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
        didSet {
            thumbSize = lineWidth - 6
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var isInteractive: Bool = false
    
    private var padding: CGFloat = 0
    private var thumbSize: CGFloat = 30
    
    private var thumbRect: CGRect = .zero
    private var paning = false
        
    private let greenRatingColor = #colorLiteral(red: 0.1294117647, green: 0.8156862745, blue: 0.4784313725, alpha: 1)
    private let greenTrackColor = #colorLiteral(red: 0.06365625043, green: 0.4012272754, blue: 0.2353352288, alpha: 0.5)
    private let yellowRatingColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1)
    private let yellowTrackColor = #colorLiteral(red: 0.4769007564, green: 0.3958523571, blue: 0.01167693827, alpha: 0.5)
    private let redRatingColor = #colorLiteral(red: 0.8588235294, green: 0.137254902, blue: 0.3764705882, alpha: 1)
    private let redTrackColor = #colorLiteral(red: 0.4028055548, green: 0.06437531699, blue: 0.176572298, alpha: 0.5)
    private let grayTrackColor = UIColor.systemGray4
                
    //MARK:- Setup
    override func awakeFromNib() {
        setupView()
    }
    
    fileprivate func setupView() {
        if isInteractive {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
            addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if style == .circle {
            return CGSize(width: bounds.height, height: bounds.height)
        }
        else {
            return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        }
    }
    
    override public class var layerClass: AnyClass {
        return ProgressLayer.self
    }
    
    private var progressLayer: ProgressLayer {
        return layer as! ProgressLayer
    }
    
    //MARK:- Animations
    func setRating(rating: CGFloat, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6, options: .curveEaseIn) {
                self.rating = rating
            }
        } else {
            self.rating = rating
        }
    }
    
    func showTutorialAnimation() {
        rating = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 40, options: [.curveEaseIn, .autoreverse]) {
            self.rating = 5
        } completion: { finished in
            if finished {
                self.rating = 0
            }
        }
        
    }
    
    //MARK:- Interaction
    @objc fileprivate func panHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: self)
        let touchRect = thumbRect.insetBy(dx: -16, dy: -16)
                                
        switch gestureRecognizer.state {
        case .possible:
            break
        case .began:
            if touchRect.contains(touchLocation) {
                paning = true
                updateRatingWithPoint(touchLocation)
                sendActions(for: .valueChanged)
            }
            break
        case.changed:
            if paning {
                updateRatingWithPoint(touchLocation)
                sendActions(for: .valueChanged)
            }
        case .ended, .cancelled, .failed:
            paning = false
            break
        @unknown default:
            break
        }
    }
        
    fileprivate func updateRatingWithPoint(_ point: CGPoint) {
        let angle = angleForPoint(point)
        
        var newRating = CGFloat(angle / 3.6)
        if newRating - rating > 50 {
            newRating = 0
        } else if newRating - rating < -50 {
            newRating = 100
        }
        
        rating = newRating

    }

    
    fileprivate func angleForPoint(_ point: CGPoint) -> Double {
        let centerOffset = CGPoint(x: point.x - bounds.midX, y: point.y -  bounds.midY)
        var angle = Double(atan2(centerOffset.y, centerOffset.x)).toDegrees()
        
        angle = 360.0 - angle
        angle = (90.0 - angle).truncatingRemainder(dividingBy: 360.0)
        while angle < 0.0 { angle += 360.0 }
        
        return angle
    }

    //MARK:- Drawing
    override func draw(_ rect: CGRect) {
        let layerRating = progressLayer.presentation() != nil ? progressLayer.presentation()!.rating : rating
        
        var trackColor: UIColor!
        var ratingColor: UIColor!
                
        switch layerRating {
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
    
    fileprivate func drawLineRating(trackColor: UIColor, ratingColor: UIColor) {
        let layerRating = progressLayer.presentation() != nil ? progressLayer.presentation()!.rating : rating

        //Round linecap is drawn outside the line, so we calculate the padding
        let linePadding = bounds.height / 2
        let lineWidth = bounds.height

        let startPoint = CGPoint(x: linePadding, y: bounds.midY)
        let endPoint = CGPoint(x: (bounds.maxX - linePadding), y: bounds.midY)
        
        let ratingX = (bounds.maxX - (linePadding * 2)) * (CGFloat(layerRating) / 100) + linePadding
        let ratingEndPoint = CGPoint(x: ratingX, y: bounds.midY)
        
        //Draw track
        let trackPath = UIBezierPath()
        trackPath.move(to: startPoint)
        trackPath.addLine(to: endPoint)
        trackPath.lineCapStyle = .round
        trackPath.lineWidth = lineWidth
        trackColor.set()
        trackPath.stroke()
        
        
        //Don't draw rating if there isn't one or is 0
        if isRatingAvailable == false || layerRating == 0 {
            return
        }
        
        //Draw ratings line
        let ratingPath = UIBezierPath()
        ratingPath.move(to: startPoint)
        ratingPath.addLine(to: ratingEndPoint)
        
        ratingPath.lineCapStyle = .round
        ratingPath.lineWidth = lineWidth
        ratingColor.set()
        ratingPath.stroke()
    }
    
    fileprivate func drawCircleRating(trackColor: UIColor, ratingColor: UIColor) {
        let layerRating = progressLayer.presentation() != nil ? progressLayer.presentation()!.rating : rating
        
        padding = lineWidth / 2
        
        let size = bounds.height
        let radius = (size / 2) - padding
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        let ratingDegree = 3.6 * Double(layerRating)
        
        let startAngle = Double(270).toRadians()
        let endAngle = (ratingDegree + 270).toRadians()
        
        //Draw track circle
        let trackPath = UIBezierPath(ovalIn: rect.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)))
        
        trackPath.lineWidth = lineWidth
        trackColor.set()
        trackPath.stroke()
                
        //Draw rating arc
        let ratingPath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: CGFloat(startAngle), endAngle:CGFloat(endAngle), clockwise: true)

        ratingPath.lineCapStyle = .round
        ratingPath.lineWidth = lineWidth
        ratingColor.set()
        ratingPath.stroke()
        
        //Draw Thumb
        if !isInteractive {
            return
        }
                         
        let x: CGFloat = rect.midX + (radius * CGFloat(cos(endAngle)))
        let y: CGFloat = rect.midY + (radius * CGFloat(sin(endAngle)))
        
        thumbRect = CGRect(x: x, y: y, width: thumbSize, height: thumbSize).offsetBy(dx: (-thumbSize / 2), dy: (-thumbSize / 2))
        let thumbPath = UIBezierPath(ovalIn: thumbRect)
        
        UIColor.white.set()
        thumbPath.fill()
    }
    
}
