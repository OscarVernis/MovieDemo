//
//  MovieDetailTitleSectionConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieDetailTitleSectionConfigurator {
    func configure(headerView: SectionTitleView, title: String, tapHandler: (() -> ())? = nil) {
        headerView.titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)!
        
        headerView.titleLabel.text = title
        headerView.tapHandler = tapHandler
    }
    
}
