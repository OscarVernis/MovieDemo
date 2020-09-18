//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UIViewController {
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
    
    var movieHeader: MovieDetailHeaderView?
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.setHidesBackButton(false, animated: true)
        navigationItem.leftItemsSupplementBackButton = true

        setupCollectionView()
        setupDataProvider()

    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(named: "AppBackgroundColor")
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
                                
        if let imageURL = movie.posterImageURL(size: .w342) {
            collectionView.backgroundColor = .clear

            let bgView = UINib(nibName: "BlurBackgroundView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! BlurBackgroundView

            bgView.imageView.af.setImage(withURL: imageURL)
            collectionView.backgroundView = bgView
        }
        
        collectionView.register(CreditCell.namedNib(), forCellWithReuseIdentifier: CreditCell.reuseIdentifier)
        collectionView.register(MoviePosterCell.namedNib(), forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.register(CreditListCell.namedNib(), forCellWithReuseIdentifier: CreditListCell.reuseIdentifier)
        collectionView.register(MovieDetailHeaderView.namedNib(), forSupplementaryViewOfKind: MovieDetailViewController.mainHeaderElementKind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier)
        collectionView.register(SectionTitleView.namedNib(), forSupplementaryViewOfKind: MovieDetailViewController.sectionTitleHeaderElementKind, withReuseIdentifier: SectionTitleView.reuseIdentifier)

        collectionView.collectionViewLayout = createLayout()
    }
    
    fileprivate func setupDataProvider() {
        dataProvider = MoviesDetailsDataProvider(movieViewModel: movie)
        dataProvider.detailsDidUpdate = {
            self.collectionView.reloadData()
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
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        
//        let image = UIImage(systemName: "arrow.left.circle.fill")
//        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
//        
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Revert Navigation Bar background to default
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithDefaultBackground()
//
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
                
                section?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Crew:
                section = sectionBuilder.createInfoListSection(withHeight: 50)
                
                section?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20)

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

// MARK: UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

// MARK: UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let s = Section(rawValue: section)!
        switch s {
        case .Header:
            return 0
        case .Cast:
            return dataProvider.movieViewModel.topCast.count
        case .Crew:
            return dataProvider.movieViewModel.topCrew.count
        case .RecommendedMovies:
            return dataProvider.movieViewModel.recommendedMovies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let s = Section(rawValue: indexPath.section)!
        switch s {
        case .Header:
            fatalError("This section should be empty!")
        case .Cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
            
            let cast = dataProvider.movieViewModel.topCast[indexPath.row]
            cell.configure(castCredit: cast)
            
            return cell
        case .Crew:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditListCell.reuseIdentifier, for: indexPath) as? CreditListCell else { fatalError() }
            
            let crew = dataProvider.movieViewModel.topCrew[indexPath.row]
            cell.configure(crewCredit: crew)
            
            cell.jobLabel.text = dataProvider.movieViewModel.crewCreditJobString(crewCreditId: crew.id!)
            
            return cell
        case .RecommendedMovies:
            guard let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell else { fatalError() }
            
            let movie = dataProvider.movieViewModel.recommendedMovies[indexPath.row]
            
            posterCell.configure(withMovie: MovieViewModel(movie: movie))
            return posterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = Section(rawValue: indexPath.section)!

        if section == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
            
            headerView.configure(movie: movie)
            self.movieHeader = headerView
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            
            var tapHandler: (() -> ())?
            switch section {
            case .Header:
                tapHandler = nil
            case .Cast:
                tapHandler = {
                    self.mainCoordinator.showCastCreditList(title: section.title(), dataProvider: StaticArrayDataProvider(models: self.dataProvider.movieViewModel.cast))
                }
            case .Crew:
                tapHandler = {                    
                    self.mainCoordinator.showCrewCreditList(title: section.title(), dataProvider: StaticArrayDataProvider(models: self.dataProvider.movieViewModel.crew))
                }
            case .RecommendedMovies:
                tapHandler = {
                    self.mainCoordinator.showMovieList(title: section.title(), dataProvider: RecommendedMoviesDataProvider(movieId: self.movie.id!))
                }
            }
            
            
            MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: section.title(), tapHandler: tapHandler)
            
            return headerView
        }
    }
    
}
