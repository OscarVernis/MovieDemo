//
//  PersonDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class PersonDetailViewController: UIViewController {
    var router: PersonDetailRouter?
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: PersonDetailDiffableDataSource!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var separator: UIView!
    
    fileprivate var showingNavBarTitle = false {
        didSet {
            if oldValue != showingNavBarTitle {
                animateTitleView(show: showingNavBarTitle)
            }
        }
    }
    
    var store: PersonDetailStore!
    var person: PersonViewModel! {
        store.person
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private var gradient: CAGradientLayer!
    private var blurAnimator: UIViewPropertyAnimator!
    
    var titleView = UILabel()
    var titleViewTopConstraint: NSLayoutConstraint!
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomBackButton()
        setupNavigationBar()
        setupAnimations()
        setup()
        setupDataSource()
        setupStore()
    }
    
    fileprivate func setupNavigationBar() {
        //Create Title
        let titleViewContainer = UIView()
        titleView.font = UIFont(name: "Avenir Next Medium", size: 20)
        titleView.textColor = .label
        titleView.alpha = 0
        
        //Setup Title
        titleViewContainer.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints =   false
        titleViewTopConstraint = titleView.topAnchor.constraint(equalTo: titleViewContainer.topAnchor, constant: 30)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: titleViewContainer.leadingAnchor, constant: 0),
            titleView.trailingAnchor.constraint(equalTo:titleViewContainer.trailingAnchor, constant: 0),
            titleViewTopConstraint,
            titleView.bottomAnchor.constraint(equalTo: titleViewContainer.bottomAnchor, constant: 0)
        ])
        navigationItem.titleView = titleViewContainer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Setup Navigation Bar Appereance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        blurAnimator?.stopAnimation(true)
    }
    
    //MARK: - Setup
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = self.dataSource.sections[sectionIndex]
            return section.sectionLayout()
        }
        
        return layout
    }
    
    fileprivate func setup() {
        //Gradient
        gradient = CAGradientLayer()
        gradient.frame = personImageView.bounds
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0.7, 1]
        personImageView.layer.mask = gradient
        
        //Setup CollectionView
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIWindow.mainWindow.topInset
        let bottomInset = UIWindow.mainWindow.bottomInset
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        
        //Setup Person
        self.title = person.name
        titleView.text = person.name
        nameLabel.text = person.name
        
        if let imageURL = self.person.profileImageURL {
            personImageView.setRemoteImage(withURL: imageURL)
        }
        
        let width = UIWindow.mainWindow.frame.width
        let height = width * 1.5
        headerHeightConstraint.constant = height
        collectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: bottomInset, right: 0)
    }
    
    fileprivate func setupDataSource() {
        dataSource = PersonDetailDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            guard let self else { fatalError() }

            return self.dataSource.cell(for: collectionView, with: indexPath, identifier: item)
        })
        
        dataSource.registerReusableViews(collectionView: collectionView)
    }
    
    fileprivate func setupStore()  {
        store.$person
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.storeDidUpdate()
        }
        .store(in: &cancellables)
        
        store.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
            if error != nil {
                self?.handleError()
                self?.store?.error = nil
            }
        }
        .store(in: &cancellables)

        store.refresh()
    }
    
    //MARK: - Actions
    fileprivate func storeDidUpdate() {
        dataSource.person = store.person
        self.dataSource.reload()
        self.collectionView.reloadData()
    }
    
    fileprivate func handleError() {
        router?.handle(error: .refreshError, shouldDismiss: true)
    }
    
}

//MARK: - Header Animations
extension PersonDetailViewController {
    fileprivate func animateTitleView(show: Bool) {
        UIView.animate(withDuration: 0.15, delay: show ? 0.05 : 0) {
            if show {
                self.titleView.alpha = 1
                self.titleViewTopConstraint.constant = 0
                self.titleView.superview?.layoutIfNeeded()
            } else {
                self.titleView.alpha = 0
                self.titleViewTopConstraint.constant = 20
                self.titleView.superview?.layoutIfNeeded()
            }
        }
        
        UIView.animate(withDuration: 0.15, delay: show ? 0 : 0.1) {
            if show {
                self.nameLabel.alpha = 0
                self.nameLabelBottomConstraint.constant = 10
                self.nameLabel.superview?.layoutIfNeeded()
            } else {
                self.nameLabel.alpha = 1
                self.nameLabelBottomConstraint.constant = 0
                self.nameLabel.superview?.layoutIfNeeded()
            }
        }
        
    }
    
    fileprivate func setupAnimations() {
        blurView.effect = nil
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            self.blurView.effect = UIBlurEffect(style: .light)
            self.separator.alpha = 1
        }

        blurAnimator.pausesOnCompletion = true
    }

    fileprivate func updateHeader() {
        let titleHeight: CGFloat = 60
        let headerHeight = collectionView.contentInset.top
        let threshold = -view.safeAreaInsets.top
        let topInset = view.safeAreaInsets.top
        let offset = collectionView.contentOffset.y

        //Adjust header size
        var newHeight = headerHeight
        if offset <= threshold {
            newHeight = abs(offset)
        } else {
            newHeight = topInset
        }

        //Animate title
        if offset > threshold - 15 {
            showingNavBarTitle = true
        } else if offset < threshold + titleHeight + 40 {
            showingNavBarTitle = false
        }

        //Set blur animation progress
        let ratio: CGFloat
        ratio = 1 - newHeight / (headerHeight * 0.6)
        blurAnimator.fractionComplete = ratio

        //Adjust header size
        if offset < -threshold {
            headerHeightConstraint.constant = newHeight

            //Adjust gradient
            var gradientFrame = personImageView.bounds
            gradientFrame.size.height = newHeight
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
        let section = dataSource.sections[indexPath.section]
        
        switch section {
        case .popular:
            let movie = person.popularMovies[indexPath.row]
            router?.showMovieDetail(movie: movie)
        case .castCredits:
            let castCredit = person.castCredits[indexPath.row]
            if let movie = castCredit.movie {
                router?.showMovieDetail(movie: movie)
            }
        case .crewCredits:
            if let crewCredit = dataSource.crewCredit(at: indexPath),
               let movie = crewCredit.movie {
                router?.showMovieDetail(movie: movie)
            }
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard dataSource.sections[indexPath.section] == .overview,
              let overviewCell = cell as? OverviewCell
        else { return }
        
        let action = UIAction { _ in
            overviewCell.textLabel.numberOfLines = 0
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadItems(at: [indexPath])
        }
        overviewCell.expandButton.addAction(action, for: .touchUpInside)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
    
}
