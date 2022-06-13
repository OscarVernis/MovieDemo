//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import SPStorkController

class MovieDetailViewController: UIViewController {
    weak var mainCoordinator: MainCoordinator?
    var dataSource: MovieDetailDataSource!
            
    private var isLoading = true
    
    private var movie: MovieViewModel!
        
    private weak var headerView: MovieDetailHeaderView?
    var collectionView: UICollectionView!
    
    required init(movie: MovieViewModel) {
        self.movie = movie
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
        setupViewModel()
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
        let layout = UICollectionViewCompositionalLayout(sectionProvider: MovieDetailLayoutProvider().createLayout)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
    
    fileprivate func setup() {
        view.backgroundColor = .asset(.AppBackgroundColor)
        collectionView.backgroundColor = .clear
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: UIWindow.topInset, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Load Background Blur View
        if let imageURL = movie.posterImageURL(size: .w342), let bgView = BlurBackgroundView.instantiateFromNib() {
            bgView.imageView.setRemoteImage(withURL: imageURL)
            collectionView.backgroundView = bgView
        }
        
        dataSource = MovieDetailDataSource(collectionView: collectionView, movie: movie)
        collectionView.dataSource = dataSource
    }
    
    fileprivate func setupViewModel()  {
        movie.didUpdate = viewModelDidUpdate
        movie.refresh()
    }
    
    fileprivate func setupHeaderView() {
        guard let headerView = headerView else { return }
        
        //Adjust the top of the Poster Image so it doesn't go unde the bar
        headerView.topConstraint.constant = UIWindow.topInset + 55
        
        headerView.playTrailerButton.addTarget(self, action: #selector(playYoutubeTrailer), for: .touchUpInside)
        
        headerView.favoriteButton?.addTarget(self, action: #selector(markAsFavorite), for: .touchUpInside)
        headerView.watchlistButton?.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        headerView.rateButton?.addTarget(self, action: #selector(addRating), for: .touchUpInside)
        
        headerView.imageTapHandler = showImage
        
        //Preload Poster Image for Image Viewer transition.
        if let url = self.movie.posterImageURL(size: .original) {
            UIImage.loadRemoteImage(url: url)
        }
        
    }
    
    fileprivate func setupTitleHeader(header: SectionTitleView, indexPath: IndexPath) {
        let section = MovieDetailDataSource.Section(rawValue: indexPath.section)!
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

    //MARK: - Actions
    
    fileprivate lazy var viewModelDidUpdate: ((Error?) -> Void) = { [weak self] error in
        guard let self = self else { return }
        
        if error != nil {
            self.mainCoordinator?.handle(error: .refreshError, shouldDismiss: true)
        }
        
        self.isLoading = false
        self.dataSource.reload()
        self.collectionView.reloadData()
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
        mainCoordinator?.showCastCreditList(title: .localized(MovieString.Cast), dataProvider: StaticArrayDataProvider(models: movie.cast))
    }
    
    fileprivate lazy var showCrew: (() -> Void) = { [unowned self] in
        mainCoordinator?.showCrewCreditList(title: .localized(MovieString.Crew), dataProvider: StaticArrayDataProvider(models: movie.crew))
    }
    
    fileprivate lazy var showRecommendedMovies: (() -> Void) = { [unowned self] in
        let provider = MoviesDataProvider(.Recommended(movieId: movie.id))
        mainCoordinator?.showMovieList(title: .localized(MovieString.RecommendedMovies), dataProvider: provider)
    }
    
    @objc fileprivate func playYoutubeTrailer() {
        guard let youtubeURL = movie.trailerURL else { return }
        
        UIApplication.shared.open(youtubeURL)
    }
    
    @objc fileprivate func markAsFavorite() {
        guard let userState = movie.userStates, let favoriteButton = headerView?.favoriteButton else {
            return
        }
        
        favoriteButton.setIsSelected(!movie.favorite, animated: true)
        favoriteButton.isUserInteractionEnabled = false
        
        if movie.favorite {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        userState.markAsFavorite(!movie.favorite) { [weak self] success in
            guard let self = self else { return }
            
            favoriteButton.isUserInteractionEnabled = true

            if !success  {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                favoriteButton.setIsSelected(self.movie.favorite, animated: false)
                self.mainCoordinator?.handle(error: .favoriteError)
            }
        }
    }
    
    @objc fileprivate func addToWatchlist() {
        guard let userState = movie.userStates, let watchlistButton = headerView?.watchlistButton else {
            return
        }
        
        watchlistButton.setIsSelected(!movie.watchlist, animated: true)
        watchlistButton.isUserInteractionEnabled = false
        
        if movie.watchlist {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        userState.addToWatchlist(!movie.watchlist) { [weak self] success in
            guard let self = self else { return }

            watchlistButton.isUserInteractionEnabled = true

            if !success {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
                self.mainCoordinator?.handle(error: .watchlistError)
            }
        }
    }
    
    @objc fileprivate func addRating() {
        guard let userState = movie.userStates,
              let watchlistButton = headerView?.watchlistButton,
              let rateButton = headerView?.rateButton
        else { return }
        
        let mrvc = MovieRatingViewController.instantiateFromStoryboard()
        mrvc.coordinator = self.mainCoordinator
        mrvc.movie = movie
        mrvc.userState = userState
        
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
        let section = MovieDetailDataSource.Section(rawValue: indexPath.section)!
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
