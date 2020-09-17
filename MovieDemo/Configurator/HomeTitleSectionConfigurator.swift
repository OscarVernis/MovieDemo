//
//  HomeTitleSectionConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct HomeTitleSectionConfigurator {
    func configure(headerView: SectionTitleView, title: String, tapHandler: (() -> ())? = nil) {
        headerView.titleLabel.text = title
        headerView.tapHandler = tapHandler
    }
}
