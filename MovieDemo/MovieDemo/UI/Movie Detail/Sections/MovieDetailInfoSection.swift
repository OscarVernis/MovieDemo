//
//  MovieDetailInfoSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailInfoSection: ConfigurableSection {
    private var bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    
    var title = NSLocalizedString("Info", comment: "")
    var movieInfo: [[String : String]]
        
    init(info: [[String : String]]) {
        self.movieInfo = info
    }
    
    var itemCount: Int {
        return movieInfo.count
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        InfoListCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createListSection(height: 50)
        
        section.contentInsets.top = 5
        section.contentInsets.bottom = self.bottomInset + 30
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
        
        MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: title)
        
        return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoListCell.reuseIdentifier, for: indexPath) as! InfoListCell

        let info = movieInfo[indexPath.row]
        MovieDetailsInfoCellConfigurator().configure(cell: cell, info: info)

        return cell
    }
    
}
