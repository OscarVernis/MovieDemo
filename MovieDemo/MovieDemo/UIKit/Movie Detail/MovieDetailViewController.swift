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
        
    private weak var headerView: MovieDetailHeaderView?
    private var gradient: CAGradientLayer!
    var collectionView: UICollectionView!
    
    var isBarHidden = true
    
    required init(store: MovieDetailStore, router: MovieDetailRouter?) {
        self.store = store
        self.router = router
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

        setupCustomBackButton()
        createCollectionView()
        setup()
        setupStore()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Bar Appearance
    var previousBarAppearance: UINavigationBarAppearance?
    var transparentBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        return appearance
    }()
    
    var defaultBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        previousBarAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.standardAppearance = transparentBarAppearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.standardAppearance = previousBarAppearance!
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
        
        //Gradient
        gradient = CAGradientLayer()
        gradient.frame = headerView.posterImageView.frame
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.black.withAlphaComponent(0.07).cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0, 0.77, 1]
        headerView.posterImageView.layer.mask = gradient
        
        headerView.playTrailerButton.addTarget(self, action: #selector(playYoutubeTrailer), for: .touchUpInside)
        
        headerView.favoriteButton?.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        headerView.watchlistButton?.addTarget(self, action: #selector(watchlistTapped), for: .touchUpInside)
        headerView.rateButton?.addTarget(self, action: #selector(addRating), for: .touchUpInside)
                        
        headerView.imageTapHandler = showImage
        
        headerView.showUserActions = store.showUserActions
        
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
        store.$movie
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                self?.storeDidUpdate()
            }
            .store(in: &cancellables)
        
        store.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if error != nil {
                    self?.show(error: .refreshError, shouldDismiss: true)
                    self?.store.error = nil
                }
            }
            .store(in: &cancellables)
        
        store.refresh()
    }

    //MARK: - Actions
    fileprivate func storeDidUpdate() {
        dataSource.movie = store.movie
        dataSource.isLoading = store.isLoading
        dataSource.reload()
        collectionView.reloadData()
    }
    
    fileprivate func show(error: UserFacingError, shouldDismiss: Bool = false) {
        router?.handle(error: error, shouldDismiss: shouldDismiss)
    }

    fileprivate lazy var showImage: (() -> Void) = { [unowned self] in
        guard let url = movie.posterImageURL(size: .original), let headerView = headerView else { return }
        let mvvc = MediaViewerViewController(imageURL: url,
                                             image: headerView.posterImageView.image,
                                             presentFromView: nil
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
        if let reusableView = view as? MovieDetailHeaderView {
            if reusableView != headerView {
                headerView = reusableView
                setupHeaderView()
            }
            
            gradient.frame = reusableView.posterImageView.frame
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
                self.navigationController?.navigationBar.standardAppearance = self.transparentBarAppearance
            } else {
                self.title = self.movie.title
                self.navigationController?.navigationBar.standardAppearance = self.defaultBarAppearance
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView else { return }
                
        let offset = scrollView.contentOffset.y
//        let threshold = headerView.posterImageView.frame.height - view.safeAreaInsets.top
        let infoViewFrame = headerView.infoView.superview!.convert(headerView.infoView.frame, to: scrollView)
        let threshold = infoViewFrame.maxY - view.safeAreaInsets.top

        //Sticky Header
        if offset < 0 {
            headerView.contentMode = .scaleAspectFill
            headerView.topImageConstraint.constant = offset < 0 ? offset : 0
            headerView.updateConstraintsIfNeeded()
            return
        }
        
        //Poster image alpha
        let imageStartingOffset: CGFloat = threshold * 0.5
        let imageOffset = offset - imageStartingOffset
        let imageThreshold = (threshold * 0.95) - imageStartingOffset
        var imageRatio = min(1, imageOffset / imageThreshold)
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

//        //Poster parallax scrolling
//        if offset < threshold, offset >= 0 {
//            headerView.topImageConstraint.constant = offset * 0.2
//            headerView.updateConstraintsIfNeeded()
//        } else {
//            headerView.topImageConstraint.constant = 0
//            headerView.updateConstraintsIfNeeded()
//        }
        
        gradient.frame = headerView.posterImageView.frame
    }
    
}
