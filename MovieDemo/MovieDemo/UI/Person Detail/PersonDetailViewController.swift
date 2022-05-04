//
//  PersonDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController, GenericCollection {
    weak var mainCoordinator: MainCoordinator!

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backButton: BlurButton!
    
    var creditsHeaderView: UICollectionReusableView?
    
    private var sections: [ConfigurableSection]!
    var person: PersonViewModel!
    
    private var gradient: CAGradientLayer!
    private var blurAnimator: UIViewPropertyAnimator!
    private var titleAnimator: UIViewPropertyAnimator?
    private var isHeaderViewCompact = false
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = []
        
        setupAnimations()
        setup()
        setupDataProvider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        blurAnimator?.stopAnimation(true)
        titleAnimator?.stopAnimation(true)
    }
    
    //MARK: - Setup
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setup() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
                
        //Gradient
        gradient = CAGradientLayer()
        gradient.frame = personImageView.bounds
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0.85, 1]
        personImageView.layer.mask = gradient
        
        //Setup CollectionView
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        dataSource = GenericCollectionDataSource(collectionView: collectionView, sections: sections)
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.delegate = self

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
        let bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)

        
        //setup Person
        self.title = person.name
        nameLabel.text = person.name
        titleNameLabel.text = person.name
        
        if let imageURL = self.person.profileImageURL {
            personImageView.setRemoteImage(withURL: imageURL)
        }
        
        let width = UIApplication.shared.windows.first(where: \.isKeyWindow)!.frame.width
        let height = width * 1.5
        headerHeightConstraint.constant = height
        collectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: bottomInset, right: 0)
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
        
        person.didUpdate = updateCollectionView
        person.refresh()
    }
    
    //MARK: - Section Loading
    fileprivate func reloadSections() {
        sections = [ConfigurableSection]()
        
        if let bio = person.biography, !bio.isEmpty {
            let bioSection = OverviewSection(overview: bio)
            sections.append(bioSection)
        }
        
        if !person.popularMovies.isEmpty {
            let popularSection = MoviesSection(title: .localized(.KnownFor), movies: person.popularMovies)
            sections.append(popularSection)
        }
        
        if !person.castCredits.isEmpty {
            let castCreditsSection = PersonCastCreditsSection(title: .localized(.Acting), credits: person.castCredits)
            sections.append(castCreditsSection)
        }
        
        let crewGrouping = Dictionary(grouping: person.crewCredits, by: \.job)
        for (key, credits) in crewGrouping {
            let crewCreditsSection = PersonCrewCreditsSection(title: key!, credits: credits)
            sections.append(crewCreditsSection)
        }

        dataSource.sections = sections
        collectionView.reloadData()
    }
    
}
    
//MARK: - Header Animations
extension PersonDetailViewController {
    fileprivate func setupAnimations() {
        blurView.effect = nil
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            self.blurView.effect = UIBlurEffect(style: .light)
        }
        
        blurAnimator.pausesOnCompletion = true
    }
    
    fileprivate func updateHeader() {
        let width = UIApplication.shared.windows.first(where: \.isKeyWindow)!.frame.width
        let height = width * 1.5
        let titleHeight: CGFloat = 60
        let navBarHeight = view.safeAreaInsets.top + 44 + titleHeight
        
        var headerHeight = height
        if collectionView.contentOffset.y <= 0 {
            headerHeight = max(abs(collectionView.contentOffset.y), navBarHeight)
        } else {
            headerHeight = navBarHeight
        }
        
        let ratio = 1 - (headerHeight - navBarHeight) / (height * 0.6)
        blurAnimator.fractionComplete = ratio
        
        if collectionView.contentOffset.y < -navBarHeight {
            headerHeightConstraint.constant = headerHeight
            
            var gradientFrame = personImageView.bounds
            gradientFrame.size.height = headerHeight
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradient.frame = gradientFrame
            CATransaction.commit()
        }
    }

}

//MARK: - CollectionView Delegate
extension PersonDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section {
        case _ as MoviesSection:
            let movie = person.popularMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
        case _ as PersonCastCreditsSection:
            let castCredit = person.castCredits[indexPath.row]
            if let movie = castCredit.movie {
                mainCoordinator.showMovieDetail(movie: movie)
            }
        case let section as PersonCrewCreditsSection:
            let crewCredit = section.credits[indexPath.row]
            if let movie = crewCredit.movie {
                mainCoordinator.showMovieDetail(movie: movie)
            }
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section {
        case _ as PersonCastCreditsSection:
            creditsHeaderView = view
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
    
}
