//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class MovieDetailViewController: UIViewController {
    private var router: (MovieDetailRouter & URLHandlingRouter)?
    private var dataSource: MovieDetailDataSource!
      
    private var store: MovieDetailStore
    private var movie: MovieViewModel {
        store.movie
    }
        
    private var backgroundView: BlurBackgroundView?
        
    private weak var headerView: MovieDetailHeaderView?
    var collectionView: UICollectionView!
            
    required init(store: MovieDetailStore, router: (MovieDetailRouter & URLHandlingRouter)?) {
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

        setupCustomBackButton()
        createCollectionView()
        setupCollectionView()
        setupDataSource()
        setupStore()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Setup Bar Appearance
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
    
    //MARK: - Setup CollectionView
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
            return MovieDetailLayoutProvider.layout(for: section)
        }
        
        layout.configuration = CompositionalLayoutBuilder.createGlobalHeaderConfiguration(height: .estimated(500), kind: MovieDetailHeaderView.headerkind)
        
        return layout
    }
    
    fileprivate func setupCollectionView() {
        view.backgroundColor = .black
        collectionView.backgroundColor = .clear
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIWindow.mainWindow.topInset
        let bottomInset =  UIWindow.mainWindow.safeAreaInsets.bottom
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset + 30, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
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
        let movieHeaderRegistration = UICollectionView.SupplementaryRegistration<MovieDetailHeaderView>(supplementaryNib: MovieDetailHeaderView.namedNib(), elementKind: MovieDetailHeaderView.headerkind) { [unowned self] header, _, _ in
            self.configureMovieHeader(header: header)
        }
        
        let sectionTitleRegistration = UICollectionView.SupplementaryRegistration<SectionTitleView>(supplementaryNib: SectionTitleView.namedNib(), elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] header, _, indexPath in
            self.configureTitleHeader(header: header, indexPath: indexPath)
        }
        
        dataSource = MovieDetailDataSource(collectionView: collectionView, supplementaryViewProvider: { collectionView, kind, indexPath in
            if kind == MovieDetailHeaderView.headerkind {
                return collectionView.dequeueConfiguredReusableSupplementary(using: movieHeaderRegistration, for: indexPath)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(using: sectionTitleRegistration, for: indexPath)
            }
        })
        
        dataSource.whereToWatchAction = {  [unowned self] in
            if let viewModel = movie.watchProviders {
                router?.showWhereToWatch(watchProviders: viewModel)
            }
        }
        
        dataSource.openSocialLink = { socialLink in
            UIApplication.shared.open(socialLink.url)
        }
        
    }
    
    //MARK: - Setup Headers
    fileprivate func configureMovieHeader(header: MovieDetailHeaderView) {
        header.configure(movie: movie,
                             isLoading: store.isLoading,
                             showUserActions: store.showUserActions)
        
        if !store.isLoading {
            header.favoriteButton?.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
            header.watchlistButton?.addTarget(self, action: #selector(watchlistTapped), for: .touchUpInside)
            header.rateButton?.addTarget(self, action: #selector(addRating), for: .touchUpInside)
        }
        
        header.imageTapHandler = showImage
                
        header.heightConstraint.constant = UIWindow.mainWindow.frame.width * 1.5
        
        self.headerView = header
    }
    
    fileprivate func configureTitleHeader(header: SectionTitleView, indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        SectionTitleView.configureForDetail(headerView: header, title: dataSource.sectionTitle(for: section))
        
        switch section {
        case .cast:
            header.tapHandler = showCast
        case .crew:
            header.tapHandler = showCrew
        case .recommended:
            header.tapHandler = showRecommendedMovies
        case .videos:
            header.tapHandler = showVideos
        default:
            header.tapHandler = nil
        }
    }
    
    //MARK: - Setup Store
    private var cancellables = Set<AnyCancellable>()

    fileprivate func setupStore()  {
        store.$movie
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                storeDidUpdate()
            }
            .store(in: &cancellables)
        
        store.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                show(error: .refreshError, shouldDismiss: true)
            }
            .store(in: &cancellables)
        
        store.refresh()
    }
    
    fileprivate func storeDidUpdate() {
        dataSource.movie = movie
        dataSource.isLoading = store.isLoading
        dataSource.showWhereToWatch = store.hasWatchProviders
        dataSource.reload()
    }

    //MARK: - Actions
    fileprivate func show(error: UserFacingError, shouldDismiss: Bool = false) {
        router?.handle(error: error, shouldDismiss: self)
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
    
    fileprivate lazy var showVideos: (() -> Void) = { [unowned self] in
        let view = MovieVideosView(viewModel: MovieVideosViewModel(videos: movie.videos))
        let vc = CustomHostingController(rootView: view)
        vc.title = MovieString.Videos.localized
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - User Actions
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
    
    //MARK: - Header Animations
    private var isBarHidden = true

    private func setNavigationBar(hidden: Bool) {
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
    
    private func updateHeader() {
        guard let headerView else { return }

        //Sticky Header
        let height = UIWindow.mainWindow.frame.width * 1.5
        if collectionView.contentOffset.y < 0 {
            let offset = abs(collectionView.contentOffset.y)
            
            //Adjust Image size and position
            headerView.topImageConstraint.constant = -offset
            headerView.heightConstraint.constant = height + abs(offset * 0.5)
            headerView.updateConstraintsIfNeeded()
            
            if headerView.isShowingPlaceholder {
                return
            }
            
            //Fade out Header Info
            let startingOffset: CGFloat = 50
            var threshold: CGFloat = 180
            var ratio = (offset - startingOffset) / (threshold - startingOffset)
            headerView.containerStackView.alpha = 1 - ratio
            backgroundView?.alpha = (1 - ratio) * 0.9
            self.navigationItem.leftBarButtonItem?.customView?.alpha = 1 - ratio
            
            //Fade out gradient
            threshold = 250
            ratio = (offset - startingOffset) / (threshold - startingOffset)

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            headerView.gradient.colors = [UIColor.black.cgColor,
                                          UIColor.black.withAlphaComponent(ratio).cgColor]
            CATransaction.commit()

            return
        }
        
        let offset = collectionView.contentOffset.y
        let infoViewFrame = headerView.infoView.superview!.convert(headerView.infoView.frame, to: collectionView)
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

// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate {    
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
        default:
            break
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
    
}
