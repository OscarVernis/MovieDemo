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
    
    var movie: MovieViewModel {
        return dataProvider.movieViewModel
    }
    
    var dataProvider: MoviesDetailsDataProvider
    
    var movieHeader: MovieDetailHeaderView?
    
    var collectionView: UICollectionView!
    
    required init(dataProvider: MoviesDetailsDataProvider) {
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Set NavigationBar/ScrollView settings for design
        self.navigationItem.largeTitleDisplayMode = .always

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)?.safeAreaInsets.top
        if topInset != nil {
            collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset!, left: 0, bottom: 0, right: 0)
        }

        //Load Background Blur View
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
        //TODO: Show Credit Movie List or Credit Detail when tapping
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .Header:
            break
        case .Cast:
            print("Tap")
        case .Crew:
            print("Tap")
        case .RecommendedMovies:
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: recommendedMovie)
        }
    }
}

// MARK: UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionIndex = Section(rawValue: section)!
        switch sectionIndex {
        case .Header:
            return 0 //Dummy section to show Header
        case .Cast:
            return movie.topCast.count
        case .Crew:
            return movie.topCrew.count
        case .RecommendedMovies:
            return movie.recommendedMovies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionIndex = Section(rawValue: indexPath.section)!
        switch sectionIndex {
        case .Header:
            fatalError("This section should be empty!")
        case .Cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as? CreditCell else { fatalError() }
            
            let cast = movie.topCast[indexPath.row]
            cell.configure(castCredit: cast)
            
            return cell
        case .Crew:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditListCell.reuseIdentifier, for: indexPath) as? CreditListCell else { fatalError() }
            
            let crew = movie.topCrew[indexPath.row]
            cell.configure(crewCredit: crew, jobsString: movie.crewCreditJobString(crewCreditId: crew.id!))
                        
            return cell
        case .RecommendedMovies:
            guard let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.reuseIdentifier, for: indexPath) as? MoviePosterCell else { fatalError() }
            
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            
            posterCell.configure(withMovie: MovieViewModel(movie: recommendedMovie))
            return posterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = Section(rawValue: indexPath.section)!

        if section == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
            
            //Adjust the top of the Poster Image so it doesn't go unde the bar
            let topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)?.safeAreaInsets.top
            headerView.topConstraint.constant = topInset! + 55
            
            headerView.configure(movie: movie)
            self.movieHeader = headerView
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            var tapHandler: (() -> ())?
            switch section {
            case .Header:
                break
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
