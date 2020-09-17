//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit


class MovieDetailViewController: UICollectionViewController {
    static let headerReuseIdentifier = "movie-detail-header-view"

    var movie: MovieViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    fileprivate func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        collectionView.register(UINib(nibName: "MoviePosterCell", bundle: .main), forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MovieDetailHeaderView", bundle: .main), forSupplementaryViewOfKind: MovieDetailViewController.headerReuseIdentifier, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier)
        
        collectionView.collectionViewLayout = createLayout()
    }
    
}

//MARK: - CollectionView CompositionalLayout
extension MovieDetailViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            
            var section: NSCollectionLayoutSection?
            
            if sectionIndex == 0 {
                section = self.createHorizontalCreditSection()
                
                let sectionHeader = self.createSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            }

            return section
        }
                
        return layout
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(500))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: MovieDetailViewController.headerReuseIdentifier, alignment: .top)
        
        return sectionHeader
    }
    
    func createHorizontalCreditSection() ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140),
                                               heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20

        return section
    }

}

extension MovieDetailViewController {
// MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
        
        headerView.configure(movie: movie)
        
        return headerView
    }
    
}
