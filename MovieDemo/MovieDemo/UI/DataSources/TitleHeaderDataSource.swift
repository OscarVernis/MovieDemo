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
    typealias HeaderConfigurator = (String, UICollectionReusableView) -> Void
    
    let title: String
    let contentDataSource: UICollectionViewDataSource
    var headerConfigurator: HeaderConfigurator = { title, header in
        guard let header = header as? SectionTitleView else { return }
        HomeTitleSectionConfigurator().configure(headerView: header, title: title)
    }
    
    init(title: String, dataSource: UICollectionViewDataSource, headerConfigurator: HeaderConfigurator? = nil) {
        self.title = title
        self.contentDataSource = dataSource
        
        if let headerConfigurator = headerConfigurator {
            self.headerConfigurator = headerConfigurator
        }
    }
    
    //Header DataSource
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as? SectionTitleView  else { fatalError() }
        
        headerConfigurator(title, sectionTitleView)
        
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
