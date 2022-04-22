//
//  MovieDetailHeaderSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailHeaderSection: ConfigurableSection {
    let movie: MovieViewModel
    var isLoading = false
        
    var imageTapHandler: (()->Void)?
    
    init(movie: MovieViewModel, isLoading: Bool = false, imageTapHandler: (()->Void)? = nil) {
        self.movie = movie
        self.imageTapHandler = imageTapHandler
        self.isLoading = isLoading
    }

    var itemCount: Int {
        return isLoading ? 1 : 0
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        MovieDetailHeaderView.registerHeader(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()

        let section = sectionBuilder.createListSection(height: 100)

        let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
        
            headerView.imageTapHandler = imageTapHandler

            let userLoggedIn = SessionManager.shared.isLoggedIn
            headerView.configure(movie: movie, showsUserActions: userLoggedIn)

            return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
    }
    
}
