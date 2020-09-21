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
    weak var mainCoordinator: MainCoordinator!
    
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    private var bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    
    enum Section: Int, CaseIterable {
        case Header
        case Cast
        case Crew
        case RecommendedMovies
        case Info
        
        var title: String {
            switch self {
            case .Header:
                return ""
            case .Cast:
                return "Cast"
            case .Crew:
                return "Crew"
            case .RecommendedMovies:
                return "Recommended Movies"
            case .Info:
                return "Info"
            }
        }
        
    }
    
    private var sections: [Section]!
    private var isLoading = true
    
    private var movie: MovieViewModel!
        
    private weak var movieHeader: MovieDetailHeaderView?
    private var collectionView: UICollectionView!
    
    required init(viewModel: MovieViewModel) {
        self.movie = viewModel
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
        
        // Only show the header and the loading cell while loading
        sections = [
            .Header,
        ]
                
        setupCollectionView()
        setupDataProvider()
    }
    
    fileprivate func reloadSections() {
        sections.removeAll()
        sections.append(.Header)

        if movie.cast.count > 0 {
            sections.append(.Cast)
        }

        if movie.crew.count > 0 {
            sections.append(.Crew)
        }

        if movie.recommendedMovies.count > 0 {
            sections.append(.RecommendedMovies)
        }
        
        if movie.infoArray.count > 0 {
            sections.append(.Info)
        }

        isLoading = false
        collectionView.reloadData()
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
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        

        //Load Background Blur View
        if let imageURL = movie.posterImageURL(size: .w342) {
            collectionView.backgroundColor = .clear

            let bgView = BlurBackgroundView.namedNib().instantiate(withOwner: nil, options: nil).first as! BlurBackgroundView

            bgView.imageView.af.setImage(withURL: imageURL)
            collectionView.backgroundView = bgView
        }
        
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MovieDetailHeaderView.registerHeader(withCollectionView: collectionView)

        LoadingCell.register(withCollectionView: collectionView)
        
        MoviePosterInfoCell.register(withCollectionView: collectionView)
        CreditCell.register(withCollectionView: collectionView)
        InfoListCell.register(withCollectionView: collectionView)

        collectionView.collectionViewLayout = createLayout()
    }
    
    fileprivate func setupDataProvider()  {
        let updateCollectionView:(Error?) -> () = { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                AlertManager.showRefreshErrorAlert(sender: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            self.reloadSections()
        }
        
        movie.didUpdate = updateCollectionView
        movie.refresh()
    }
    
}

//MARK: - CollectionView CompositionalLayout
extension MovieDetailViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var section: NSCollectionLayoutSection?
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            let sectionType = self?.sections[sectionIndex]

            switch sectionType {
            case .Header: //This is a dummy section used to contain the main header, it will not display any items
                section = sectionBuilder.createEmptySection(withHeight: 150)
                
                let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Cast:
                section = sectionBuilder.createHorizontalCreditSection()
                
                section?.contentInsets.top = 8
                section?.contentInsets.bottom = 0
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Crew:
                section = sectionBuilder.createSelfSizingListSection(withHeight: 50)
                
                section?.contentInsets.top = 5
                section?.contentInsets.bottom = 10

                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .RecommendedMovies:
                section = sectionBuilder.createHorizontalPosterSection()
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.contentInsets.top = 12
                section?.contentInsets.bottom = 10
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Info:
                section = sectionBuilder.createInfoListSection(withHeight: 50)
                
                section?.contentInsets.top = 5
                section?.contentInsets.bottom = (self?.bottomInset ?? 0) + 10

                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .none:
                break
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
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header:
            break
        case .Cast:
            break
        case .Crew:
            break
        case .RecommendedMovies:
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: recommendedMovie)
        case .Info:
            break
        }
    }
}

// MARK: UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = self.sections[section]
        switch sectionType {
        case .Header:
            return isLoading ? 1 : 0 //Dummy section to show Header, if loading shows LoadingCell
        case .Cast:
            return movie.topCast.count
        case .Crew:
            return movie.topCrew.count
        case .RecommendedMovies:
            return movie.recommendedMovies.count
        case .Info:
            return movie.infoArray.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header:
            if isLoading {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
                
                return cell
            } else {
                fatalError("Should be empty!")
            }
        case .Cast:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as! CreditCell
            
            let cast = movie.topCast[indexPath.row]
            cell.configure(castCredit: cast)
            
            return cell
        case .Crew:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoListCell.reuseIdentifier, for: indexPath) as! InfoListCell
            
            let crew = movie.topCrew[indexPath.row]
            CrewCreditInfoListCellConfigurator().configure(cell: cell, with: crew)
                        
            return cell
        case .RecommendedMovies:
            let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
            
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            
            MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: recommendedMovie))
            
            return posterCell
        case .Info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoListCell.reuseIdentifier, for: indexPath) as! InfoListCell
            
            let info = movie.infoArray[indexPath.row]
            MovieDetailsInfoCellConfigurator().configure(cell: cell, info: info)
                                    
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = self.sections[indexPath.section]

        if sectionType == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
            
            //Adjust the top of the Poster Image so it doesn't go unde the bar
            headerView.topConstraint.constant = topInset + 55
            
            headerView.configure(movie: movie)
            self.movieHeader = headerView
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            var tapHandler: (() -> ())?
            switch sectionType {
            case .Header:
                break
            case .Cast:
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showCastCreditList(title: sectionType.title, dataProvider: StaticArrayDataProvider(models: self.movie.cast))
                }
            case .Crew:
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showCrewCreditList(title: sectionType.title, dataProvider: StaticArrayDataProvider(models: self.movie.crew))
                }
            case .RecommendedMovies:
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: MovieListDataProvider(.Recommended(movieId: self.movie.id!)))
                }
            case .Info:
                break
            }
            
            MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: sectionType.title, tapHandler: tapHandler)
            
            return headerView
        }
    }
    
}
