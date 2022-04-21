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
    
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    private var bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    
    private var sections = [ConfigurableSection]()
    private var isLoading = true
    
    private var movie: MovieViewModel!
        
    private weak var headerView: MovieDetailHeaderView?
    private weak var actionsCell: UserActionsCell?
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
        view.backgroundColor = .appBackgroundColor
        collectionView.backgroundColor = .clear
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        //Load Background Blur View
        if let imageURL = movie.posterImageURL(size: .w342) {
            collectionView.backgroundColor = .clear

            let bgView = BlurBackgroundView.namedNib().instantiate(withOwner: nil, options: nil).first as! BlurBackgroundView

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
    
    fileprivate func updateActionButtons() {
        guard let actionsCell = actionsCell else { return }

        actionsCell.favoriteButton.setIsSelected(movie.favorite, animated: false)
        actionsCell.watchlistButton.setIsSelected(movie.watchlist, animated: false)
        actionsCell.rateButton.setIsSelected(movie.rated, animated: false)
    }
    
    //MARK: - Sections
    fileprivate func addSection(_ section: ConfigurableSection, validate: Bool? = nil) {
        //Only add the section if validation passes
        if let validate = validate, validate == false { return }
        
        sections.append(section)
    }
    
    fileprivate func reloadSections() {
        sections.removeAll()
        
        addSection(MovieDetailHeaderSection(movie: movie, imageTapHandler: showImage))
        addSection(MovieDetailOverviewSection(title: NSLocalizedString("Overview", comment: ""), overview: movie.overview),
                   validate: !movie.overview.isEmpty)
        addSection(LoadingSection(),
                   validate: isLoading)
        addSection(MovieDetailTrailerSection(),
                   validate: movie.trailerURL != nil)
        addSection(MovieDetailCastSection(cast: movie.topCast, titleHeaderButtonHandler: showCast),
                   validate: !movie.topCast.isEmpty)
        addSection(MovieDetailCrewSection(crew: movie.topCrew, titleHeaderButtonHandler: showCrew),
                    validate: !movie.topCrew.isEmpty)
        addSection(MovieDetailVideoSection(videos: movie.videos),
                   validate: !movie.videos.isEmpty)
        addSection(MoviesSection(title: NSLocalizedString("Recommended Movies", comment: ""), movies: movie.recommendedMovies, titleHeaderButtonHandler: showRecommendedMovies),
                   validate: !movie.recommendedMovies.isEmpty)
        addSection(MovieDetailInfoSection(info: movie.infoArray),
                   validate: !movie.infoArray.isEmpty)

        dataSource.sections = sections
        collectionView.reloadData()
    }

    //MARK: - Actions
    fileprivate func showRecommendedMovies() {
        let provider = MoviesDataProvider(.Recommended(movieId: movie.id))
        mainCoordinator.showMovieList(title: NSLocalizedString("Recommended Movies", comment: ""), dataProvider: provider)
    }
    
    fileprivate func showCast() {
        mainCoordinator.showCastCreditList(title: NSLocalizedString("Cast", comment: ""), dataProvider: StaticArrayDataProvider(models: self.movie.cast))
    }
    
    fileprivate func showCrew() {
        mainCoordinator.showCrewCreditList(title: NSLocalizedString("Crew", comment: ""), dataProvider: StaticArrayDataProvider(models: self.movie.crew))
    }
    
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
        transitionDelegate.showIndicator = false
        
        mrvc.didUpdateRating = {
            self.actionsCell?.rateButton.setIsSelected(self.movie.rated, animated: false)
            self.actionsCell?.watchlistButton.setIsSelected(self.movie.watchlist, animated: false)
        }
        
        self.present(mrvc, animated: true)
    }

    fileprivate func showImage() {
        guard let url = self.movie.posterImageURL(size: .original), let headerView = headerView else { return }
        let mvvc = MediaViewerViewController(imageURL: url,
                                             image: headerView.posterImageView.image,
                                             presentFromView: headerView.posterImageView
        )
        present(mvvc, animated: true)
    }
    
    @objc fileprivate func playYoutubeTrailer() {
        guard let youtubeURL = movie.trailerURL else { return }
        
        UIApplication.shared.open(youtubeURL)
    }
    
}

// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let reusableView = view as? MovieDetailHeaderView else { return }
        
        headerView = reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch cell {
        case let cell as UserActionsCell:
            cell.favoriteButton.addTarget(self, action: #selector(markAsFavorite), for: .touchUpInside)
            cell.watchlistButton.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
            cell.rateButton.addTarget(self, action: #selector(addRating), for: .touchUpInside)

            actionsCell = cell
            updateActionButtons()
        case let cell as TrailerCell:
            cell.trailerButton.addTarget(self, action: #selector(playYoutubeTrailer), for: .touchUpInside)
        default:
            break
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
