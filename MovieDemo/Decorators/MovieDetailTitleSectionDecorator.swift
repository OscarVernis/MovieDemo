//
//  MovieDetailTitleSectionDecorator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieDetailTitleSectionDecorator {
    func configure(headerView: SectionTitleView, title: String, tapHandler: (() -> ())? = nil) {
        headerView.titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)!
        
        headerView.titleLabel.text = title
        
        if tapHandler == nil {
            headerView.actionButton.isHidden = true
        } else {
            headerView.actionButton.isHidden = false
            headerView.tapHandler = tapHandler
        }
    }
    
}
