//
//  TitleHeaderDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

class TitleHeaderDataSource: NSObject, UICollectionViewDataSource {
    typealias TitleHeaderConfigurator = (SectionTitleView, String) -> Void
    
    let title: String
    let contentDataSource: UICollectionViewDataSource
    var headerConfigurator: TitleHeaderConfigurator
    
    init(title: String, dataSource: UICollectionViewDataSource, headerConfigurator: @escaping TitleHeaderConfigurator = SectionTitleView.configureForHome(headerView:title:)) {
        self.title = title
        self.contentDataSource = dataSource
        self.headerConfigurator = headerConfigurator
    }
    
    //Header DataSource
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as? SectionTitleView  else { fatalError() }
        
        headerConfigurator(sectionTitleView, title)
        
        return sectionTitleView
    }
    
    //Content DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contentDataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return contentDataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
}
