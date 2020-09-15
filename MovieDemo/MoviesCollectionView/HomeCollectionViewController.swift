//
//  HomeViewControllerCollectionViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

enum Section: Int, CaseIterable {
    case NowPlaying
    case Popular
    case TopRated
    case Upcoming
}

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    var dataProvider = MovieListDataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self
//        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search

        dataProvider.currentService = .NowPlaying
        collectionView.collectionViewLayout = createLayout()
        
        dataProvider.completionHandler = {
            self.collectionView.reloadData()
        }
        
        collectionView.register(UINib(nibName: "BannerMovieCell", bundle: .main), forCellWithReuseIdentifier: BannerMovieCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MovieListCell", bundle: .main), forCellWithReuseIdentifier: MovieListCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MovieInfoCell", bundle: .main), forCellWithReuseIdentifier: MovieInfoCell.reuseIdentifier)
    }
    
}
 
    //MARK: - CollectionView CompositionalLayout

extension HomeCollectionViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            var section: NSCollectionLayoutSection? = nil
            
            switch sectionType {
            case .NowPlaying:
                section = self.createBannerSection()
            case .Popular:
                section = self.createHorizontalPosterSection()
            case .TopRated:
                section = self.createDecoratedListSection()
            case .Upcoming:
                section = self.createInfoListSection()
            }

            return section
        }
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: HomeCollectionViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }
    
    func createBannerSection() ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
//        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .estimated(44))
//        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: titleSize,
//            elementKind: ConferenceVideoSessionsViewController.titleElementKind,
//            alignment: .top)
//        section.boundarySupplementaryItems = [titleSupplementary]
        
        return section
    }
    
    func createHorizontalPosterSection() ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(132),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 20

        return section
    }
    
    func createDecoratedListSection() ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: HomeCollectionViewController.sectionBackgroundDecorationElementKind)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        section.decorationItems = [sectionBackgroundDecoration]
                
        return section
    }
    
    func createInfoListSection() ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
                
        return section
    }
    
}

//MARK: - CollectionView DataSource
extension HomeCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Section.TopRated.rawValue, dataProvider.movies.count >= 5 {
            return 10
        } else {
            return dataProvider.movies.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        let movie = dataProvider.movies[indexPath.row]
        
        var cell: UICollectionViewCell!
        switch section {
        case .NowPlaying:
            guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerMovieCell.reuseIdentifier, for: indexPath) as? BannerMovieCell else { fatalError() }
            
            bannerCell.configureBackdrop(withMovie: movie)
            cell = bannerCell
        case .Popular:
            guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerMovieCell.reuseIdentifier, for: indexPath) as? BannerMovieCell else { fatalError() }
            
            bannerCell.configurePoster(withMovie: movie)
            cell = bannerCell
        case .TopRated:
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCell.reuseIdentifier, for: indexPath) as? MovieListCell else { fatalError() }
            
            let isLastCell = indexPath.row == 9 //dataProvider.movies.count - 1
            listCell.configure(withMovie: movie, showSeparator: !isLastCell)
            cell = listCell
        case .Upcoming:
            guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCell.reuseIdentifier, for: indexPath) as? MovieInfoCell else { fatalError() }
            
            infoCell.configure(withMovie: movie)
            cell = infoCell
        }
        
        return cell
    }
}
