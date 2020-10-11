//
//  PersonDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class PersonDetailViewController: UIViewController, GenericCollection {
    weak var mainCoordinator: MainCoordinator!
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    private var sections: [ConfigurableSection]!
    var person: PersonViewModel!
    
    private var blurAnimator: UIViewPropertyAnimator!
    private var gradient: CAGradientLayer!
    
    //MARK:- View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        sections = []
        
        setup()
        setupDataProvider()
    }
    
    deinit {
        blurAnimator.stopAnimation(true)
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
    
    //MARK:- Setup
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func setup() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        blurView.effect = nil
        self.titleNameLabel.transform = self.titleNameLabel.transform.translatedBy(x: -10, y: 50)
        self.titleNameLabel.transform = self.titleNameLabel.transform.scaledBy(x: 1.1, y: 1.1)
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            UIView.animateKeyframes(withDuration: 1, delay: 0) {
                self.blurView.effect = UIBlurEffect(style: .light)

                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.2) {
                    self.nameLabel.alpha = 0
                }

                UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                    self.titleNameLabel.alpha = 1
                    self.titleNameLabel.transform = .identity
                }
            }
        }
        
        //Gradient
        gradient = CAGradientLayer()
        gradient.frame = personImageView.bounds
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.black.withAlphaComponent(0.5).cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0.86, 0.93, 1]
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
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        //setup Person
        self.title = person.name
        nameLabel.text = person.name
        titleNameLabel.text = person.name
        
        if let imageURL = self.person.profileImageURL {
            personImageView.af.setImage(withURL: imageURL)
        }
        
        let width = UIApplication.shared.windows.first(where: \.isKeyWindow)!.frame.width
        let height = width * 1.5
        headerHeightConstraint.constant = height
        collectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
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
        
        dataSource.sections = sections
        collectionView.reloadData()
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
            break
//            let movie = person.castCredits[indexPath.row]
//            mainCoordinator.showMovieDetail(movie: movie)
        default:
            break
        }
        
}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = UIApplication.shared.windows.first(where: \.isKeyWindow)!.frame.width
        let height = width * 1.5
        let navBarHeight = view.safeAreaInsets.top + 44
        
        var headerHeight = height
        if scrollView.contentOffset.y <= 0 {
            headerHeight = max(abs(scrollView.contentOffset.y), navBarHeight)
        } else {
            headerHeight = navBarHeight
        }
        
        let ratio = 1 - (headerHeight - navBarHeight) / (height * 0.7)
        blurAnimator.fractionComplete = ratio
        
        headerHeightConstraint.constant = headerHeight
        
        var gradientFrame = personImageView.bounds
        gradientFrame.size.height = headerHeight
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradient.frame = gradientFrame
        CATransaction.commit()
    }
    
}
