//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    var router: MovieDetailRouter?
    var dataSource: MovieDetailDataSource!
      
    private var store: MovieDetailStore
    private var movie: MovieViewModel {
        store.movie
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private var backgroundView: BlurBackgroundView?
        
    private weak var headerView: MovieDetailHeaderView?
    var collectionView: UICollectionView!
    
    private var isBarHidden = true
    
    required init(store: MovieDetailStore, router: MovieDetailRouter?) {
        self.store = store
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self

        setupCustomBackButton()
        createCollectionView()
        setup()
        setupDataSource()
        setupStore()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Bar Appearance
    var currentBarAppearance: UINavigationBarAppearance?
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentBarAppearance {
            navigationController?.navigationBar.standardAppearance = currentBarAppearance
        } else {
            configureWithTransparentNavigationBarAppearance()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        currentBarAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    //MARK: - Setup
    func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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
        view.backgroundColor = .black
        collectionView.backgroundColor = .clear
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIWindow.mainWindow.topInset
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Load Background Blur View
        backgroundView =  BlurBackgroundView.instantiateFromNib()
        collectionView.backgroundView = backgroundView
        if let imageURL = movie.posterImageURL(size: .w342) {
            backgroundView?.imageView.setRemoteImage(withURL: imageURL)
        } else {
            backgroundView?.imageView.image = .asset(.PosterPlaceholder)
        }
    }
    
    fileprivate func setupDataSource() {
        dataSource = MovieDetailDataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            self.dataSource.cell(for: collectionView, with: indexPath, identifier: itemIdentifier)
        })
        
        dataSource.registerReusableViews(collectionView: collectionView)
        
        dataSource.openSocialLink = { socialLink in
            UIApplication.shared.open(socialLink.url)
        }
    }
    
    fileprivate func setupHeaderView() {
        guard let headerView = headerView else { return }
                
        headerView.playTrailerButton.addTarget(self, action: #selector(playYoutubeTrailer), for: .touchUpInside)
        
        headerView.favoriteButton?.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        headerView.watchlistButton?.addTarget(self, action: #selector(watchlistTapped), for: .touchUpInside)
        headerView.rateButton?.addTarget(self, action: #selector(addRating), for: .touchUpInside)
                        
        headerView.imageTapHandler = showImage
        
        headerView.showUserActions = store.showUserActions
        
        headerView.heightConstraint.constant = UIWindow.mainWindow.frame.width * 1.5
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
        store.$movie
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                self?.storeDidUpdate()
            }
            .store(in: &cancellables)
        
        store.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.show(error: .refreshError, shouldDismiss: true)
            }
            .store(in: &cancellables)
        
        store.refresh()
    }

    //MARK: - Actions
    fileprivate func storeDidUpdate() {
        dataSource.movie = movie
        dataSource.isLoading = store.isLoading
        dataSource.reload()
    }
    
    fileprivate func show(error: UserFacingError, shouldDismiss: Bool = false) {
        router?.handle(error: error, shouldDismiss: shouldDismiss)
    }

    fileprivate lazy var showImage: (() -> Void) = { [unowned self] in
        guard headerView?.isShowingPlaceholder == false,
                let image = headerView?.posterImageView.image,
                let headerView = headerView else { return }
        let mvvc = MediaViewerViewController(image: image,
                                             presentFromView: headerView.posterImageView
        )
        present(mvvc, animated: true)
    }
    
    fileprivate lazy var showCast:(() -> Void) = { [unowned self] in
        router?.showCastCreditList(credits: movie.cast)
    }
    
    fileprivate lazy var showCrew: (() -> Void) = { [unowned self] in
        router?.showCrewCreditList(credits: movie.crew)
    }
    
    fileprivate lazy var showRecommendedMovies: (() -> Void) = { [unowned self] in
        router?.showRecommendedMovies(for: movie.id)
    }
    
    @objc fileprivate func playYoutubeTrailer() {
        guard let youtubeURL = movie.trailerURL else { return }
        
        UIApplication.shared.open(youtubeURL)
    }
    
    //MARK: User Actions
    @objc fileprivate func favoriteTapped() {
        Task { await markAsFavorite() }
    }
    
    fileprivate func markAsFavorite() async {
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
        
        let success = await store.markAsFavorite(!movie.favorite)
        
        favoriteButton.isUserInteractionEnabled = true
        
        if !success  {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            favoriteButton.setIsSelected(movie.favorite, animated: false)
            show(error: .favoriteError)
            
        }
        
    }
    
    @objc fileprivate func watchlistTapped() {
        Task { await addToWatchlist() }
    }
    
    fileprivate func addToWatchlist() async {
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
        
        let success = await store.addToWatchlist(!movie.watchlist)
        watchlistButton.isUserInteractionEnabled = true
        
        if !success {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            watchlistButton.setIsSelected(movie.watchlist, animated: false)
            show(error: .watchlistError)
        }
        
    }
    
    @objc fileprivate func addRating() {
        guard let watchlistButton = headerView?.watchlistButton,
              let rateButton = headerView?.rateButton
        else { return }
        
        router?.showMovieRatingView(store: store, successHandler: {
            rateButton.setIsSelected(self.movie.rated, animated: false)
            watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
        })
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
            router?.showPersonProfile(person)
        case .crew:
            let crewCredit = movie.topCrew[indexPath.row]
            let person = crewCredit.person()
            router?.showPersonProfile(person)
        case .recommended:
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            router?.showMovieDetail(movie: recommendedMovie)
        case .videos:
            let video = movie.videos[indexPath.row]
            UIApplication.shared.open(video.youtubeURL)
        default:
            break
        }
    }
    
    //MARK: - Header Animations
    func setNavigationBar(hidden: Bool) {
        guard isBarHidden != hidden, let navBar = navigationController?.navigationBar else { return }
        
        isBarHidden = hidden
        UIView.transition(with: navBar, duration: 0.3, options: .transitionCrossDissolve) {
            if self.isBarHidden {
                self.title = ""
                self.configureWithTransparentNavigationBarAppearance()
            } else {
                self.title = self.movie.title
                self.configureWithDefaultNavigationBarAppearance()
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView else { return }

        //Sticky Header
        let height = UIWindow.mainWindow.frame.width * 1.5
        if scrollView.contentOffset.y < 0 {
            let offset = abs(scrollView.contentOffset.y)
            
            //Adjust Image size and position
            headerView.topImageConstraint.constant = -offset
            headerView.heightConstraint.constant = height + abs(offset * 0.5)
            headerView.updateConstraintsIfNeeded()
            
            if headerView.isShowingPlaceholder {
                return
            }
            
            //Fade out Header Info
            let startingOffset: CGFloat = 50
            let threshold: CGFloat = 180
            let ratio = (offset - startingOffset) / (threshold - startingOffset)
            headerView.containerStackView.alpha = 1 - ratio
            backgroundView?.alpha = (1 - ratio) * 0.9
            self.navigationItem.leftBarButtonItem?.customView?.alpha = 1 - ratio
            
            //Fade out gradient
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            headerView.gradient.colors = [UIColor.black.cgColor,
                                          UIColor.black.withAlphaComponent(ratio * 0.7).cgColor]
            CATransaction.commit()

            return
        }
        
        let offset = scrollView.contentOffset.y
        let infoViewFrame = headerView.infoView.superview!.convert(headerView.infoView.frame, to: scrollView)
        let threshold = infoViewFrame.maxY - view.safeAreaInsets.top
        
        //Poster image alpha
        let imageStartingOffset: CGFloat = threshold * 0.5
        let imageOffset = offset - imageStartingOffset
        let imageThreshold = threshold - imageStartingOffset
        let imageRatio = min(1, imageOffset / imageThreshold)
        headerView.posterImageView.alpha = 1 - imageRatio
        
        //Info alpha
        let startingOffset: CGFloat = threshold * 0.7
        let infoRatio = min(1, (offset - startingOffset) / (threshold - startingOffset))
        headerView.infoView.alpha = 1 - infoRatio
        
        //Show/Hide NavigationBar
        if infoRatio >= 1 {
            setNavigationBar(hidden: false)
        } else {
            setNavigationBar(hidden: true)
        }

        //Poster parallax scrolling
        if offset < threshold, offset >= 0 {
            headerView.topImageConstraint.constant = offset * 0.1
            headerView.updateConstraintsIfNeeded()
        } else {
            headerView.topImageConstraint.constant = 0
            headerView.updateConstraintsIfNeeded()
        }
    }
    
}
