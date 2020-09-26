//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage
import Lightbox
import SPStorkController

class MovieDetailViewController: UIViewController {    
    weak var mainCoordinator: MainCoordinator!
    
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    private var bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    
    enum Section: Int, CaseIterable {
        case Header
        case UserActions
        case Overview
        case Loading
        case Trailer
        case Cast
        case Crew
        case Videos
        case RecommendedMovies
        case Info
        
        var title: String {
            switch self {
            case .Header, .UserActions, .Loading, .Trailer:
                return ""
            case .Overview:
                return NSLocalizedString("Overview", comment: "")
            case .Cast:
                return NSLocalizedString("Cast", comment: "")
            case .Crew:
                return NSLocalizedString("Crew", comment: "")
            case .RecommendedMovies:
                return NSLocalizedString("Recommended Movies", comment: "")
            case .Info:
                return NSLocalizedString("Info", comment: "")
            case .Videos:
                return NSLocalizedString("Videos", comment: "")
            }
        }
        
    }
    
    private var sections = [Section]()
    private var isLoading = true
    
    private var movie: MovieViewModel!
        
    private weak var actionsCell: UserActionsCell?
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
    
    //MARK:- Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadSections()
        
        setupCollectionView()
        setupDataProvider()
    }
    
    fileprivate func reloadSections() {
        sections.removeAll()
        sections.append(.Header)
        
        if SessionManager.shared.isLoggedIn {
            sections.append(.UserActions)
        }
        
        if !movie.overview.isEmpty {
            sections.append(.Overview)
        }
        
        if isLoading {
            sections.append(.Loading)
            return
        }
        
        if movie.trailerURL != nil {
            sections.append(.Trailer)
        }
        
        if !movie.cast.isEmpty {
            sections.append(.Cast)
        }

        if !movie.crew.isEmpty {
            sections.append(.Crew)
        }
        
        if !movie.videos.isEmpty {
            sections.append(.Videos)
        }
        
        if !movie.recommendedMovies.isEmpty {
            sections.append(.RecommendedMovies)
        }
        
        if !movie.infoArray.isEmpty {
            sections.append(.Info)
        }

        collectionView.reloadData()
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .appBackgroundColor
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
        
        //Register Cells and Headers
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MovieDetailHeaderView.registerHeader(withCollectionView: collectionView)

        LoadingCell.register(withCollectionView: collectionView)
        
        UserActionsCell.register(withCollectionView: collectionView)
        OverviewCell.register(withCollectionView: collectionView)
        TrailerCell.register(withCollectionView: collectionView)
        YoutubeVideoCell.register(withCollectionView: collectionView)
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
            
            self.isLoading = false
            self.reloadSections()
        }
        
        movie.didUpdate = updateCollectionView
        movie.refresh()
    }
    
    fileprivate func updateActionButtons() {
        guard let actionsCell = actionsCell else { return }

        actionsCell.favoriteButton.setIsSelected(movie.favorite, animated: false)
        actionsCell.watchlistButton.setIsSelected(movie.watchlist, animated: false)
        actionsCell.rateButton.setIsSelected(movie.rated, animated: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            SPStorkController.updatePresentingController(parent: self)
        }
    }
    
    //MARK:- Actions
    @objc fileprivate func markAsFavorite() {
        if !SessionManager.shared.isLoggedIn {
            return
        }
        
        actionsCell?.favoriteButton.setIsSelected(!movie.favorite, animated: true)
        actionsCell?.favoriteButton.isUserInteractionEnabled = false
        
        if movie.favorite {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        movie.markAsFavorite(!movie.favorite) { [weak self] success in
            guard let self = self else { return }
            
            self.actionsCell?.favoriteButton.isUserInteractionEnabled = true

            if !success  {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                self.actionsCell?.favoriteButton.setIsSelected(self.movie.favorite, animated: false)
                AlertManager.showFavoriteAlert(text: NSLocalizedString("Couldn't set favorite! Please try again.", comment: ""), sender: self)
            }
        }
    }
    
    @objc fileprivate func addToWatchlist() {
        if !SessionManager.shared.isLoggedIn {
            return
        }
        
        actionsCell?.watchlistButton.setIsSelected(!movie.watchlist, animated: true)
        actionsCell?.watchlistButton.isUserInteractionEnabled = false
        
        if movie.watchlist {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        movie.addToWatchlist(!movie.watchlist) { [weak self] success in
            guard let self = self else { return }

            self.actionsCell?.watchlistButton.isUserInteractionEnabled = true

            if !success {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                self.actionsCell?.watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
                AlertManager.showWatchlistAlert(text: NSLocalizedString("Couldn't add to watchlist! Please try again.", comment: ""), sender: self)
            }
        }
    }
    
    @objc fileprivate func addRating() {
        let mrvc = MovieRatingViewController.instantiateFromStoryboard()
        mrvc.movie = movie
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        mrvc.transitioningDelegate = transitionDelegate
        mrvc.modalPresentationStyle = .custom
        mrvc.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.customHeight = 450
        transitionDelegate.showCloseButton = true
        transitionDelegate.showIndicator = false
        
        mrvc.didUpdateRating = {
            self.actionsCell?.rateButton.setIsSelected(self.movie.rated, animated: false)
            self.actionsCell?.watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
        }
        
        self.present(mrvc, animated: true)
    }

    fileprivate func showImage() {
        guard let url = self.movie.posterImageURL(size: .original) else { return }
        
        LightboxConfig.PageIndicator.enabled = false
        LightboxConfig.makeLoadingIndicator = {
            ActivityIndicator()
        }

        let images = [LightboxImage(imageURL: url)]
        let controller = LightboxController(images: images)
        controller.dynamicBackground = true
        self.present(controller, animated: true, completion: nil)
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
                section = sectionBuilder.createWideSection(withHeight: 1)
                
                let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .UserActions: //This is a dummy section used to contain the Actions Header
                section = sectionBuilder.createWideSection(withHeight: 80)
            case .Overview:
                section = sectionBuilder.createEstimatedSection(withHeight: 50)
                section?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

                let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Loading:
                section = sectionBuilder.createEstimatedSection(withHeight: 150)
            case .Trailer:
                section = sectionBuilder.createInfoListSection(withHeight: 65)
                section?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            case .Cast:
                section = sectionBuilder.createHorizontalCreditSection()
                
                section?.contentInsets.top = 8
                section?.contentInsets.bottom = 0
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Crew:
                section = sectionBuilder.createTwoColumnListSection(withHeight: 50)
                
                section?.contentInsets.top = 5
                section?.contentInsets.bottom = 10

                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Videos:
                section = sectionBuilder.createBannerSection()
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.orthogonalScrollingBehavior = .continuous
                section?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
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
                section?.contentInsets.bottom = (self?.bottomInset ?? 0) + 30

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
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header, .UserActions, .Overview, .Trailer, .Loading, .Info, .Videos:
            break
        case .Cast:
            let castCredit = movie.cast[indexPath.row]
            let dataProvider = MovieListDataProvider(.DiscoverWithCast(castId: castCredit.id))
            let title = String(format: NSLocalizedString("Movies with: %@", comment: ""), castCredit.name)
            mainCoordinator.showMovieList(title: title, dataProvider: dataProvider)
            break
        case .Crew:
            let crewCredit = movie.topCrew[indexPath.row]
            let dataProvider = MovieListDataProvider(.DiscoverWithCrew(crewId: crewCredit.id))
            let title = String(format: NSLocalizedString("Movies by: %@", comment: ""), crewCredit.name)
            mainCoordinator.showMovieList(title: title, dataProvider: dataProvider)
            break
        case .RecommendedMovies:
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: recommendedMovie)
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
            return 0 //Dummy section to show Header, if loading shows LoadingCell
        case .UserActions:
            return 1
        case .Cast:
            return movie.topCast.count
        case .Crew:
            return movie.topCrew.count
        case .RecommendedMovies:
            return movie.recommendedMovies.count
        case .Info:
            return movie.infoArray.count
        case .Trailer:
            return movie.youtubeKey != nil ? 1 : 0
        case .Overview:
            return 1
        case .Videos:
            return movie.videos.count
        case .Loading:
            return isLoading ? 1 : 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header:
            fatalError("Should be empty!")
        case .UserActions:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserActionsCell.reuseIdentifier, for: indexPath) as! UserActionsCell
            
            cell.favoriteButton.addTarget(self, action: #selector(markAsFavorite), for: .touchUpInside)
            cell.watchlistButton.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
            cell.rateButton.addTarget(self, action: #selector(addRating), for: .touchUpInside)

            actionsCell = cell
            updateActionButtons()
            
            return cell
        case .Cast:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as! CreditCell
            
            let cast = movie.topCast[indexPath.row]
            CastCreditCellConfigurator().configure(cell: cell, with: cast)
            
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
        case .Trailer:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCell.reuseIdentifier, for: indexPath) as! TrailerCell
            
            cell.youtubeURL = movie.trailerURL
            
            return cell
        case .Videos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YoutubeVideoCell.reuseIdentifier, for: indexPath) as! YoutubeVideoCell
            
            let movieVideo = movie.videos[indexPath.row]
            cell.configure(video: movieVideo)
            
            return cell
        case .Overview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as! OverviewCell
            
            cell.textLabel.text = movie.overview
            
            return cell
        case .Loading:
            if isLoading {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
                
                return cell
            } else {
                fatalError("Should be empty!")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = self.sections[indexPath.section]

        if sectionType == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
                        
            //Adjust the top of the Poster Image so it doesn't go unde the bar
            headerView.topConstraint.constant = topInset + 55
            headerView.imageTapHandler = { [weak self] in
                guard let self = self else { return }
                    
                self.showImage()
            }
            
            headerView.configure(movie: movie)
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            var tapHandler: (() -> ())?
            switch sectionType {
            case .Header, .UserActions, .Overview, .Trailer, .Loading, .Info, .Videos:
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
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: MovieListDataProvider(.Recommended(movieId: self.movie.id)))
                }
            }
            
            MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: sectionType.title, tapHandler: tapHandler)
            
            return headerView
        }
    }
    
}

