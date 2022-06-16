//
//  CircularRating.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct Rating: View {
    enum Style: Int {
        case circle
        case line
    }
    
    private let greenRatingColor = Color(uiColor: #colorLiteral(red: 0.1294117647, green: 0.8156862745, blue: 0.4784313725, alpha: 1))
    private let greenTrackColor = Color(uiColor: #colorLiteral(red: 0.06365625043, green: 0.4012272754, blue: 0.2353352288, alpha: 0.5))
    private let yellowRatingColor = Color(uiColor: #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1))
    private let yellowTrackColor = Color(uiColor: #colorLiteral(red: 0.4769007564, green: 0.3958523571, blue: 0.01167693827, alpha: 0.5))
    private let redRatingColor = Color(uiColor: #colorLiteral(red: 0.8588235294, green: 0.137254902, blue: 0.3764705882, alpha: 1))
    private let redTrackColor = Color(uiColor: #colorLiteral(red: 0.4028055548, green: 0.06437531699, blue: 0.176572298, alpha: 0.5))
    private let grayTrackColor = Color(uiColor: UIColor.systemGray3)
    
    var lineWidth: CGFloat
    var progress: CGFloat? = nil
    var style: Style
    
    init(style: Style = .circle, progress: UInt?, lineWidth: CGFloat = 3) {
        self.style = style
        self.lineWidth = lineWidth
        self.progress = progress != nil ? CGFloat(progress!) : nil
    }
    
    var body: some View {
        switch style {
        case .line:
            line()
        case .circle:
            circle()
        }
    }
    
    fileprivate func line() -> some View {
        return ZStack(alignment: .leading) {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: lineWidth / 2)
                    .fill(trackColor)
                if progress != nil {
                    RoundedRectangle(cornerRadius: lineWidth / 2)
                        .fill(ratingColor)
                        .frame(width: proxy.size.width * correctedProgress, height: lineWidth)
                }
            }
        }
        .frame(height: lineWidth)
    }
    
    fileprivate func circle() -> some View {
        return ZStack {
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: correctedProgress)
                .stroke(ratingColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .padding(lineWidth)
    }
    
    fileprivate var correctedProgress: CGFloat {
        progress == nil ? 0 : (progress! / 100)
    }
    
    fileprivate var trackColor: Color {
        guard let progress = progress else {
            return grayTrackColor
        }

        switch progress {
        case 0...40:
            return redTrackColor
        case 41...70:
            return yellowTrackColor
        case 71...100:
            return greenTrackColor
        default:
            return greenTrackColor
        }
    }
    
    fileprivate var ratingColor: Color {
        guard let progress = progress else {
            return Color.clear
        }
        
        switch progress {
        case 0...40:
            return redRatingColor
        case 41...70:
            return yellowRatingColor
        case 71...100:
            return greenRatingColor
        default:
            return greenTrackColor
        }
    }
}

struct CircularRating_Previews: PreviewProvider {
    static var lineWidth: CGFloat = 10
    static var circleWidth: CGFloat = 5
    
    static var previews: some View {
        VStack {
            VStack(alignment: .center, spacing: 20) {
                Rating(style: .line, progress: 100, lineWidth: lineWidth)
                Rating(style: .line, progress: 80, lineWidth: lineWidth)
                Rating(style: .line, progress: 70, lineWidth: lineWidth)
                Rating(style: .line, progress: 23, lineWidth: lineWidth)
                Rating(style: .line, progress: 0, lineWidth: lineWidth)
                Rating(style: .line, progress: nil, lineWidth: lineWidth)
            }
            .padding(10)
            
            HStack(alignment: .center, spacing: 5) {
                Rating(progress: 100, lineWidth: circleWidth)
                Rating(progress: 80, lineWidth: circleWidth)
                Rating(progress: 70, lineWidth: circleWidth)
                Rating(progress: 23, lineWidth: circleWidth)
                Rating(progress: 0, lineWidth: circleWidth)
                Rating(progress: nil, lineWidth: circleWidth)
            }
            .frame(height: 40)
            .padding(10)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)

    }
}
