//
//  SectionBackgroundDecorationView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class SectionBackgroundDecorationView: UICollectionReusableView {
    static let elementKind = "SectionBackgroundDecorationView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension SectionBackgroundDecorationView {
    func configure() {
        backgroundColor = UIColor(named: "SectionBackgroundColor")
        layer.cornerRadius = 12
    }
}
