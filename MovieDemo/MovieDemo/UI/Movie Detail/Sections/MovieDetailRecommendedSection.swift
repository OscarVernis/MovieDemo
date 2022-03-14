//
//  MovieDetailRecommendedSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailRecommendedSection: ConfigurableSection {
    var title: String
    var movies: [MovieViewModel]
    
    var titleHeaderButtonHandler: (()->Void)?
    
    init(title: String, movies: [MovieViewModel]) {
        self.title = title
        self.movies = movies
    }
    
    var itemCount: Int {
        return movies.count
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        MoviePosterInfoCell.register(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createHorizontalPosterSection()
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
        
        MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: title, tapHandler: titleHeaderButtonHandler)
        
        return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
        
        let recommendedMovie = movies[indexPath.row]
        MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: recommendedMovie)
        
        return posterCell
    }
    
}
