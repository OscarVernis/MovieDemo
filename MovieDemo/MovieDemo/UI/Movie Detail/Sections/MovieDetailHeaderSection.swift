//
//  MovieDetailHeaderSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailHeaderSection: ConfigurableSection {
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    let movie: MovieViewModel
        
    var imageTapHandler: (()->Void)?
    
    init(movie: MovieViewModel, imageTapHandler: (()->Void)? = nil) {
        self.movie = movie
        self.imageTapHandler = imageTapHandler
    }

    var itemCount: Int {
        return 0
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        MovieDetailHeaderView.registerHeader(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()

        let section = sectionBuilder.createSection(groupHeight: .absolute(44))

        let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView

            //Adjust the top of the Poster Image so it doesn't go unde the bar
            headerView.topConstraint.constant = topInset + 55
            headerView.imageTapHandler = imageTapHandler

            let userLoggedIn = SessionManager.shared.isLoggedIn
            headerView.configure(movie: movie, showsUserActions: userLoggedIn)

            return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
    
}
