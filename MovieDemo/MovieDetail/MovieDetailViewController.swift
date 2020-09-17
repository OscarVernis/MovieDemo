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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
//        createDataSource()
        
        dataProvider = MoviesDetailsDataProvider(movieViewModel: movie)
        dataProvider.detailsDidUpdate = {
            
        }
        
        dataProvider.creditsDidUpdate = {
            self.collectionView.reloadData()
        }
        
        dataProvider.recommendedMoviesDidUpdate = {
            self.collectionView.reloadData()
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
        
        collectionView.register(CreditCell.namedNib(), forCellWithReuseIdentifier: CreditCell.reuseIdentifier)
        collectionView.register(MoviePosterCell.namedNib(), forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.register(MovieDetailHeaderView.namedNib(), forSupplementaryViewOfKind: MovieDetailViewController.mainHeaderElementKind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier)
        collectionView.register(SectionTitleView.namedNib(), forSupplementaryViewOfKind: MovieDetailViewController.sectionTitleHeaderElementKind, withReuseIdentifier: SectionTitleView.reuseIdentifier)

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

////MARK: - CollectionView Diffable DataSource
//extension MovieDetailViewController {
//    func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: cell)
//    }
//
//    func reloadData(animated: Bool = false) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
//
//        let cast = dataProvider.movie.cast! as [AnyHashable]
//        let crew = dataProvider.movie.cast! as [AnyHashable]
//        let movies = dataProvider.recommendedMovies as [AnyHashable]
//
//        snapshot.appendSections(Section.allCases)
//        snapshot.appendItems(cast, toSection: .Cast)
//        snapshot.appendItems(crew, toSection: .Crew)
//        snapshot.appendItems(movies, toSection: .RecommendedMovies)
//
//        dataSource?.apply(snapshot, animatingDifferences: animated)
//    }
//
//    func cell(collectioView: UICollectionView, indexPath: IndexPath, model: AnyHashable) -> UICollectionViewCell {
//        let section = Section(rawValue: indexPath.section)!
//        switch section {
//        case .Header:
//            fatalError("This section should be empty!")
//        case .Cast:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
//
//            let cast = model as! CastCredit
//            cell.configure(castCredit: cast)
//
//            return cell
//        case .Crew:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
//
//            let crew = model as! CrewCredit
//            cell.configure(crewCredit: crew)
//
//            return cell
//        case .RecommendedMovies:
//            guard let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell else { fatalError() }
//
//            let movie = model as! Movie
//
//            posterCell.configure(withMovie: MovieViewModel(movie: movie))
//            return posterCell
//        }
//    }
//
//}

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
            return dataProvider.movieViewModel.cast.count
        case .Crew:
            return dataProvider.movieViewModel.topCrew.count
        case .RecommendedMovies:
            return dataProvider.movieViewModel.recommendedMovies.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let s = Section(rawValue: indexPath.section)!
        switch s {
        case .Header:
            fatalError("This section should be empty!")
        case .Cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
            
            let cast = dataProvider.movieViewModel.cast[indexPath.row]
            cell.configure(castCredit: cast)
            
            return cell
        case .Crew:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
            
            let crew = dataProvider.movieViewModel.topCrew[indexPath.row]
            cell.configure(crewCredit: crew)
            
            return cell
        case .RecommendedMovies:
            guard let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell else { fatalError() }
            
            let movie = dataProvider.movieViewModel.recommendedMovies[indexPath.row]
            
            posterCell.configure(withMovie: MovieViewModel(movie: movie))
            return posterCell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = Section(rawValue: indexPath.section)!

        if section == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
            
            headerView.configure(movie: movie)
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            
            //TODO: Open Movie List when tapping header button
            var tapHandler: (() -> ())? =  nil
            if section == .RecommendedMovies {
                tapHandler = {
                    print("Recommended Movies")
                }
            }
            
            MovieDetailTitleSectionDecorator().configure(headerView: headerView, title: section.title(), tapHandler: tapHandler)
            
            return headerView
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Show Cast List when tapping
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .Header:
            print("Tap")
        case .Cast:
            print("Tap")
        case .Crew:
            print("Tap")
        case .RecommendedMovies:
            let movie = dataProvider.movieViewModel.recommendedMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
        }
        
    }
    
}
