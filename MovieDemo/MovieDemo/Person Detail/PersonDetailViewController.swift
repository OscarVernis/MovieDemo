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
    
    //MARK:- View Controller
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
        blurAnimator.stopAnimation(true)
        titleAnimator?.stopAnimation(true)
    }
    
    //MARK:- Setup
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
            let bioSection = MovieDetailOverviewSection(overview: bio)
            sections.append(bioSection)
        }
        
        if !person.popularMovies.isEmpty {
            let popularSection = MovieDetailRecommendedSection(title: NSLocalizedString("Known For", comment: ""), movies: person.popularMovies)
            sections.append(popularSection)
        }
        
        if !person.castCredits.isEmpty {
            let castCreditsSection = PersonCastCreditsSection(title: NSLocalizedString("Acting", comment: ""), credits: person.castCredits)
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
    
    //MARK:- Header Animations
extension PersonDetailViewController {
    fileprivate func setupAnimations() {
        blurView.effect = nil
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            self.blurView.effect = UIBlurEffect(style: .light)
        }
        
        blurAnimator.pausesOnCompletion = true
    }
    
    fileprivate func setIsHeaderViewCompact(_ isHeaderViewCompact: Bool, animated: Bool) {
        self.isHeaderViewCompact = isHeaderViewCompact
        titleAnimator?.stopAnimation(true)
        
        let titleHeight:CGFloat = 60
        let navBarHeight = view.safeAreaInsets.top + 44 + (isHeaderViewCompact ? 0 : titleHeight)
        
        let animationDuration = animated ? 0.3 : 0
        if isHeaderViewCompact {
            self.titleNameLabel.transform = self.titleNameLabel.transform.translatedBy(x: 0, y: 0)
            self.titleNameLabel.transform = self.titleNameLabel.transform.scaledBy(x: 1.1, y: 1.1)
            self.headerHeightConstraint.constant = navBarHeight
            titleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeIn) {
                UIView.animateKeyframes(withDuration: animationDuration, delay: 0) {
                    self.personImageView.superview?.layoutIfNeeded()

                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                        self.nameLabel.alpha = 0
                        self.nameLabel.transform = self.nameLabel.transform.scaledBy(x: 0.4, y: 0.4)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                        self.titleNameLabel.alpha = 1
                        self.titleNameLabel.transform = .identity
                    }
                }
            }
        } else {
            titleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) {
                self.headerHeightConstraint.constant = navBarHeight
                UIView.animateKeyframes(withDuration: animationDuration, delay: 0) {
                    self.personImageView.superview?.layoutIfNeeded()
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                        self.titleNameLabel.alpha = 0
                        self.titleNameLabel.transform = self.titleNameLabel.transform.translatedBy(x: 0, y: 15)
                        self.titleNameLabel.transform = self.titleNameLabel.transform.scaledBy(x: 1.1, y: 1.1)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                        self.nameLabel.alpha = 1
                        self.nameLabel.transform = .identity
                    }
                }
            }
        }
        
        titleAnimator?.pausesOnCompletion = true
        titleAnimator?.startAnimation()
        
    }
    
    fileprivate func updateHeader() {
        let width = UIApplication.shared.windows.first(where: \.isKeyWindow)!.frame.width
        let height = width * 1.5
        let titleHeight:CGFloat = 60
        let navBarHeight = view.safeAreaInsets.top + 44 + titleHeight
        
        var headerHeight = height
        if collectionView.contentOffset.y <= 0 {
            headerHeight = max(abs(collectionView.contentOffset.y), navBarHeight)
        } else {
            headerHeight = navBarHeight
        }
        
//        if creditsHeaderView != nil {
//            let creditsSectionPos = creditsHeaderView!.frame.origin.y - collectionView.contentOffset.y - navBarHeight
//            if creditsSectionPos < 0 {
//                if !isHeaderViewCompact {
//                    setIsHeaderViewCompact(true, animated: true)
//                }
//            } else {
//                if isHeaderViewCompact {
//                    setIsHeaderViewCompact(false, animated: true)
//                }
//            }
//        }
        
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

//MARK:- CollectionView Delegate
extension PersonDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section {
        case _ as MovieDetailRecommendedSection:
            let movie = person.popularMovies[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
        case _ as PersonCastCreditsSection:
            let movie = person.castCredits[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
        case let section as PersonCrewCreditsSection:
            let movie = section.credits[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
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
