//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit


class MovieDetailViewController: UICollectionViewController {
    enum Section: Int, CaseIterable {
        case Header
        case Cast
        case Crew
        case RecommendedMovies
        
        func title() -> String {
            switch self {
            case .Header:
                return ""
            case .Cast:
                return "Cast"
            case .Crew:
                return "Crew"
            case .RecommendedMovies:
                return "Recommended Movies"
            }
        }
        
    }
    
    static let mainHeaderElementKind = "movie-detail-header-view"
    static let sectionTitleHeaderElementKind = "section-header-element-kind"

    weak var mainCoordinator: MainCoordinator!
    
    var movie: MovieViewModel!
    var dataProvider: MoviesDetailsDataProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        dataProvider = MoviesDetailsDataProvider(movie: movie.movie)
        dataProvider.detailsDidUpdate = {
            
        }
        
        dataProvider.creditsDidUpdate = {
            self.collectionView.reloadSections(IndexSet(integer: Section.Cast.rawValue))
            self.collectionView.reloadSections(IndexSet(integer: Section.Crew.rawValue))
        }
        
        dataProvider.recommendedMoviesDidUpdate = {
            self.collectionView.reloadSections(IndexSet(integer: Section.RecommendedMovies.rawValue))
        }
        
        dataProvider.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set Navigation Bar background transparent
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Revert Navigation Bar background to default
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    fileprivate func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        collectionView.register(UINib(nibName: CreditCell.reuseIdentifier, bundle: .main), forCellWithReuseIdentifier: CreditCell.reuseIdentifier)
        collectionView.register(UINib(nibName: MoviePosterCell.reuseIdentifier, bundle: .main), forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.register(UINib(nibName: MovieDetailHeaderView.reuseIdentifier, bundle: .main), forSupplementaryViewOfKind: MovieDetailViewController.mainHeaderElementKind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier)
        collectionView.register(UINib(nibName: SectionTitleView.reuseIdentifier, bundle: .main), forSupplementaryViewOfKind: MovieDetailViewController.sectionTitleHeaderElementKind, withReuseIdentifier: SectionTitleView.reuseIdentifier)


        
        collectionView.collectionViewLayout = createLayout()
    }
    
}

//MARK: - CollectionView CompositionalLayout
extension MovieDetailViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var section: NSCollectionLayoutSection?
            let s = Section(rawValue: sectionIndex)!
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            switch s {
            case .Header: //This is a dummy section used to contain the main header, it will not display any items
                section = sectionBuilder.createEmptySection()
                
                let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Cast:
                section = sectionBuilder.createHorizontalCreditSection()
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Crew:
                section = sectionBuilder.createHorizontalCreditSection()
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .RecommendedMovies:
                section = sectionBuilder.createHorizontalPosterSection()
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            }
            

            return section
        }
                
        return layout
    }

}

extension MovieDetailViewController {
// MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let s = Section(rawValue: section)!
        switch s {
        case .Header:
            return 0
        case .Cast:
            return dataProvider.movie.cast?.count ?? 0
        case .Crew:
            return dataProvider.movie.crew?.count ?? 0
        case .RecommendedMovies:
            return dataProvider.recommendedMovies.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let s = Section(rawValue: indexPath.section)!
        switch s {
        case .Header:
            fatalError("This section should be empty!")
        case .Cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
            
            let cast = dataProvider.movie.cast![indexPath.row]
            cell.configure(castCredit: cast)
            
            return cell
        case .Crew:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
            
            let crew = dataProvider.movie.crew![indexPath.row]
            cell.configure(crewCredit: crew)
            
            return cell
        case .RecommendedMovies:
            guard let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell else { fatalError() }
            
            let movie = dataProvider.recommendedMovies[indexPath.row]
            
            posterCell.configure(withMovie: MovieViewModel(movie: movie))
            return posterCell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let s = Section(rawValue: indexPath.section)!

        if s == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
            
            headerView.configure(movie: movie)
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            let section = Section(rawValue: indexPath.section)!
            MovieDetailTitleSectionDecorator().configure(headerView: headerView, title: section.title())
            
            return headerView
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .Header:
            print("Tap")
        case .Cast:
            print("Tap")
        case .Crew:
            print("Tap")
        case .RecommendedMovies:
            let movie = dataProvider.recommendedMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
        }
        
    }
    
}
