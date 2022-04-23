//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import SPStorkController
import SwiftUI

class MovieDetailViewController: UIViewController, GenericCollection {
    weak var mainCoordinator: MainCoordinator!
    var dataSource: GenericCollectionDataSource!
        
    let topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    
    private var sections = [ConfigurableSection]()
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
        reloadSections()
        setupDataProvider()
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
    fileprivate func setup() {
        view.backgroundColor = .asset(.AppBackgroundColor)
        collectionView.backgroundColor = .clear
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Load Background Blur View
        if let imageURL = movie.posterImageURL(size: .w342), let bgView = BlurBackgroundView.instantiateFromNib() {
            bgView.imageView.setRemoteImage(withURL: imageURL)
            collectionView.backgroundView = bgView
        }
        
        dataSource = GenericCollectionDataSource(collectionView: collectionView, sections: sections)
    }
    
    fileprivate func setupDataProvider()  {
        movie.didUpdate = { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                AlertManager.showRefreshErrorAlert(sender: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            self.isLoading = false
            self.reloadSections()
        }
        
        movie.refresh()
    }
    
    fileprivate func setupHeaderView() {
        guard let headerView = headerView else { return }
        
        //Adjust the top of the Poster Image so it doesn't go unde the bar
        headerView.topConstraint.constant = topInset + 55
        
        headerView.playTrailerButton.addTarget(self, action: #selector(playYoutubeTrailer), for: .touchUpInside)
        
        headerView.favoriteButton?.addTarget(self, action: #selector(markAsFavorite), for: .touchUpInside)
        headerView.watchlistButton?.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        headerView.rateButton?.addTarget(self, action: #selector(addRating), for: .touchUpInside)
        updateActionButtons()
        
        //Preload Poster Image for Image Viewer transition.
        if let url = self.movie.posterImageURL(size: .original) {
            UIImage.loadRemoteImage(url: url)
        }
    }
    
    fileprivate func updateActionButtons() {
        guard let headerView = headerView else { return }
        
        headerView.favoriteButton?.setIsSelected(movie.favorite, animated: false)
        headerView.watchlistButton?.setIsSelected(movie.watchlist, animated: false)
        headerView.rateButton?.setIsSelected(movie.rated, animated: false)
    }
    
    //MARK: - Sections
    fileprivate func reloadSections() {
        sections.removeAll()
        
        sections.append(MovieDetailHeaderSection(movie: movie, isLoading: isLoading, imageTapHandler: showImage))
        
        if !movie.topCast.isEmpty {
            sections.append(MovieDetailCastSection(cast: movie.topCast, titleHeaderButtonHandler: showCast))
        }
        
        if !movie.topCrew.isEmpty {
            sections.append(MovieDetailCrewSection(crew: movie.topCrew, titleHeaderButtonHandler: showCrew))
        }
        
        if !movie.videos.isEmpty {
            sections.append(MovieDetailVideoSection(videos: movie.videos))
        }
        
        if !movie.recommendedMovies.isEmpty {
            sections.append(MoviesSection(title: .localized(.RecommendedMovies), movies: movie.recommendedMovies, titleHeaderButtonHandler: showRecommendedMovies))
        }
        
        if !movie.infoArray.isEmpty {
            sections.append(MovieDetailInfoSection(info: movie.infoArray))
        }

        dataSource.sections = sections
        collectionView.reloadData()
    }

    //MARK: - Actions
    fileprivate func showImage() {
        guard let url = self.movie.posterImageURL(size: .original), let headerView = headerView else { return }
        let mvvc = MediaViewerViewController(imageURL: url,
                                             image: headerView.posterImageView.image,
                                             presentFromView: headerView.posterImageView
        )
        present(mvvc, animated: true)
    }
    
    fileprivate func showCast() {
        mainCoordinator.showCastCreditList(title: .localized(.Cast), dataProvider: StaticArrayDataProvider(models: self.movie.cast))
    }
    
    fileprivate func showCrew() {
        mainCoordinator.showCrewCreditList(title: .localized(.Crew), dataProvider: StaticArrayDataProvider(models: self.movie.crew))
    }
    
    fileprivate func showRecommendedMovies() {
        let provider = MoviesDataProvider(.Recommended(movieId: movie.id))
        mainCoordinator.showMovieList(title: .localized(.RecommendedMovies), dataProvider: provider)
    }
    
    @objc fileprivate func playYoutubeTrailer() {
        guard let youtubeURL = movie.trailerURL else { return }
        
        UIApplication.shared.open(youtubeURL)
    }
    
    @objc fileprivate func markAsFavorite() {
        guard SessionManager.shared.isLoggedIn, let favoriteButton = headerView?.favoriteButton else {
            return
        }
        
        favoriteButton.setIsSelected(!movie.favorite, animated: true)
        favoriteButton.isUserInteractionEnabled = false
        
        if movie.favorite {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        movie.markAsFavorite(!movie.favorite) { [weak self] success in
            guard let self = self else { return }
            
            favoriteButton.isUserInteractionEnabled = true

            if !success  {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                favoriteButton.setIsSelected(self.movie.favorite, animated: false)
                AlertManager.showFavoriteAlert(text: .localized(.FavoriteError), sender: self)
            }
        }
    }
    
    @objc fileprivate func addToWatchlist() {
        guard SessionManager.shared.isLoggedIn, let watchlistButton = headerView?.watchlistButton else {
            return
        }
        
        watchlistButton.setIsSelected(!movie.watchlist, animated: true)
        watchlistButton.isUserInteractionEnabled = false
        
        if movie.watchlist {
            UISelectionFeedbackGenerator().selectionChanged()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        movie.addToWatchlist(!movie.watchlist) { [weak self] success in
            guard let self = self else { return }

            watchlistButton.isUserInteractionEnabled = true

            if !success {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
                AlertManager.showWatchlistAlert(text: .localized(.WatchListError), sender: self)
            }
        }
    }
    
    @objc fileprivate func addRating() {
        guard SessionManager.shared.isLoggedIn,
              let watchlistButton = headerView?.watchlistButton,
              let rateButton = headerView?.rateButton
        else { return }
        
        let mrvc = MovieRatingViewController.instantiateFromStoryboard()
        mrvc.movie = movie
        
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
        guard let reusableView = view as? MovieDetailHeaderView else { return }
        
        if reusableView != headerView {
            headerView = reusableView
            setupHeaderView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch(section) {
        case _ as MovieDetailCastSection:
            let castCredit = movie.topCast[indexPath.row]
            let person = castCredit.person()
            mainCoordinator.showPersonProfile(person)
        case _ as MovieDetailCrewSection:
            let crewCredit = movie.topCrew[indexPath.row]
            let person = crewCredit.person()
            mainCoordinator.showPersonProfile(person)
        case _ as MoviesSection:
            let recommendedMovie = movie.recommendedMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: recommendedMovie)
        case _ as MovieDetailVideoSection:
            let video = movie.videos[indexPath.row]
            UIApplication.shared.open(video.youtubeURL)
            
                        
        default:
            break
        }
        
    }

}
