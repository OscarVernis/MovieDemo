//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine
import SPStorkController

class MovieDetailViewController: UIViewController {
    weak var mainCoordinator: MainCoordinator?
    var dataSource: MovieDetailDataSource!
      
    private var store: MovieDetailStore
    private var movie: MovieViewModel {
        store.movie
    }
    
    private var cancellables = Set<AnyCancellable>()
        
    private weak var headerView: MovieDetailHeaderView?
    var collectionView: UICollectionView!
    
    required init(store: MovieDetailStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self

        createCollectionView()
        setup()
        setupStore()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        //Update Rating View if appeareance changes
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            SPStorkController.updatePresentingController(parent: self)
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Setup
    func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = self.dataSource.sections[sectionIndex]
            return section.sectionLayout()
        }
        
        return layout
    }
    
    fileprivate func setup() {
        view.backgroundColor = .asset(.AppBackgroundColor)
        collectionView.backgroundColor = .clear
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIWindow.mainWindow.topInset
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Load Background Blur View
        if let imageURL = movie.posterImageURL(size: .w342), let bgView = BlurBackgroundView.instantiateFromNib() {
            bgView.imageView.setRemoteImage(withURL: imageURL)
            collectionView.backgroundView = bgView
        }
        
        dataSource = MovieDetailDataSource(collectionView: collectionView, movie: movie, isLoading: store.isLoading)
        dataSource.isLoading = store.isLoading
        collectionView.dataSource = dataSource
    }
    
    fileprivate func setupHeaderView() {
        guard let headerView = headerView else { return }
        
        //Adjust the top of the Poster Image so it doesn't go unde the bar
        headerView.topConstraint.constant = UIWindow.mainWindow.topInset + 55
        
        headerView.playTrailerButton.addTarget(self, action: #selector(playYoutubeTrailer), for: .touchUpInside)
        
        headerView.favoriteButton?.addTarget(self, action: #selector(markAsFavorite), for: .touchUpInside)
        headerView.watchlistButton?.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        headerView.rateButton?.addTarget(self, action: #selector(addRating), for: .touchUpInside)
                
        headerView.imageTapHandler = showImage
        
        headerView.showUserActions = store.hasUserStates
        
        //Preload Poster Image for Image Viewer transition.
        if let url = self.movie.posterImageURL(size: .original) {
            UIImage.loadRemoteImage(url: url)
        }
        
    }
    
    fileprivate func setupTitleHeader(header: SectionTitleView, indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        switch section {
        case .cast:
            header.tapHandler = showCast
        case .crew:
            header.tapHandler = showCrew
        case .recommended:
            header.tapHandler = showRecommendedMovies
        default:
            header.tapHandler = nil
        }
    }
    
    fileprivate func setupStore()  {
        store.$movie.sink { [weak self] movie in
            self?.didUpdate(movie: movie)
        }
        .store(in: &cancellables)
        
        store.$error.sink { [weak self] error in
            if error != nil {
                self?.show(error: .refreshError, shouldDismiss: true)
                self?.store.error = nil
            }
        }
        .store(in: &cancellables)
        
        store.refresh()
    }

    //MARK: - Actions
    fileprivate func didUpdate(movie: MovieViewModel) {
        dataSource.movie = movie
        dataSource.isLoading = store.isLoading
        dataSource.reload()
        collectionView.reloadData()
    }
    
    fileprivate func show(error: UserFacingError, shouldDismiss: Bool = false) {
        mainCoordinator?.handle(error: error, shouldDismiss: shouldDismiss)
    }

    fileprivate lazy var showImage: (() -> Void) = { [unowned self] in
        guard let url = movie.posterImageURL(size: .original), let headerView = headerView else { return }
        let mvvc = MediaViewerViewController(imageURL: url,
                                             image: headerView.posterImageView.image,
                                             presentFromView: headerView.posterImageView
        )
        present(mvvc, animated: true)
    }
    
    fileprivate lazy var showCast:(() -> Void) = { [unowned self] in
        mainCoordinator?.showCastCreditList(title: .localized(MovieString.Cast), dataProvider: BasicProvider(models: movie.cast))
    }
    
    fileprivate lazy var showCrew: (() -> Void) = { [unowned self] in
        mainCoordinator?.showCrewCreditList(title: .localized(MovieString.Crew), dataProvider: BasicProvider(models: movie.crew))
    }
    
    fileprivate lazy var showRecommendedMovies: (() -> Void) = { [unowned self] in
        let provider = MoviesProvider(.Recommended(movieId: movie.id))
        mainCoordinator?.showMovieList(title: .localized(MovieString.RecommendedMovies), dataProvider: provider)
    }
    
    @objc fileprivate func playYoutubeTrailer() {
        guard let youtubeURL = movie.trailerURL else { return }
        
        UIApplication.shared.open(youtubeURL)
    }
    
    @objc fileprivate func markAsFavorite() {
        guard let favoriteButton = headerView?.favoriteButton else {
            return
        }
        
        favoriteButton.setIsSelected(!movie.favorite, animated: true)
        favoriteButton.isUserInteractionEnabled = false
        
        if movie.favorite {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        store.markAsFavorite(!movie.favorite) { [weak self] success in
            guard let self = self else { return }
            
            favoriteButton.isUserInteractionEnabled = true

            if !success  {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                favoriteButton.setIsSelected(self.movie.favorite, animated: false)
                show(error: .favoriteError)
            }
        }
    }
    
    @objc fileprivate func addToWatchlist() {
        guard let watchlistButton = headerView?.watchlistButton else {
            return
        }
        
        watchlistButton.setIsSelected(!movie.watchlist, animated: true)
        watchlistButton.isUserInteractionEnabled = false
        
        if movie.watchlist {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        store.addToWatchlist(!movie.watchlist) { [weak self] success in
            guard let self = self else { return }

            watchlistButton.isUserInteractionEnabled = true

            if !success {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
                self.show(error: .watchlistError)
            }
        }
    }
    
    @objc fileprivate func addRating() {
        guard let watchlistButton = headerView?.watchlistButton,
              let rateButton = headerView?.rateButton
        else { return }
        
        let mrvc = MovieRatingViewController.instantiateFromStoryboard()
        mrvc.coordinator = self.mainCoordinator
        mrvc.store = store
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        mrvc.transitioningDelegate = transitionDelegate
        mrvc.modalPresentationStyle = .custom
        mrvc.modalPresentationCapturesStatusBarAppearance = true
        transitionDelegate.customHeight = 450
        transitionDelegate.showIndicator = false
        
        mrvc.didUpdateRating = {
            rateButton.setIsSelected(self.movie.rated, animated: false)
            watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
        }
        
        self.present(mrvc, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {

        //Configure Movie Header
        if let reusableView = view as? MovieDetailHeaderView, reusableView != headerView {
            headerView = reusableView
            setupHeaderView()
        }
        
        //Configure TitleHeader
        if let titleHeader = view as? SectionTitleView {
            setupTitleHeader(header: titleHeader, indexPath: indexPath)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        switch section {
        case .cast:
            let castCredit = movie.topCast[indexPath.row]
            let person = castCredit.person()
            mainCoordinator?.showPersonProfile(person)
        case .crew:
            let crewCredit = movie.topCrew[indexPath.row]
            let person = crewCredit.person()
            mainCoordinator?.showPersonProfile(person)
        case .recommended:
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            mainCoordinator?.showMovieDetail(movie: recommendedMovie)
        case .videos:
            let video = movie.videos[indexPath.row]
            UIApplication.shared.open(video.youtubeURL)
        default:
            break
        }
    }

}
