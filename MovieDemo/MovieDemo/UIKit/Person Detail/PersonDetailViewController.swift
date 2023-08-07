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
    var dataSource: PersonDetailDataSource!
    
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
        setupTitleView()
        setupBlurAnimator()
        setup()
        setupDataSource()
        setupStore()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        blurAnimator?.stopAnimation(true)
    }
    
    //MARK: - Bar Appearance
    override func viewWillAppear(_ animated: Bool) {
        configureWithTransparentNavigationBarAppearance()
    }
    
    //MARK: - Setup
    fileprivate func setupTitleView() {
        //Create Title
        let titleViewContainer = UIView()
        titleViewContainer.clipsToBounds = false
        titleView.font = UIFont(name: "Avenir Next Medium", size: 20)
        titleView.textColor = .label
        titleView.alpha = 0
        
        //Setup Title
        titleViewContainer.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints =   false
        titleViewTopConstraint = titleView.topAnchor.constraint(equalTo: titleViewContainer.topAnchor, constant: 20)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: titleViewContainer.leadingAnchor, constant: 0),
            titleView.trailingAnchor.constraint(equalTo:titleViewContainer.trailingAnchor, constant: 0),
            titleViewTopConstraint,
            titleView.bottomAnchor.constraint(equalTo: titleViewContainer.bottomAnchor, constant: 0)
        ])
        navigationItem.titleView = titleViewContainer
    }
    
    fileprivate func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = self.dataSource.sections[sectionIndex]
            return PersonDetailLayoutProvider.layout(for: section)
        }
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)

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
        
        let width = UIWindow.mainWindow.frame.width
        let height = width * 1.5
        let bottomInset = UIWindow.mainWindow.bottomInset
        headerHeightConstraint.constant = height
        collectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: bottomInset, right: 0)
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: height, left: 0, bottom: bottomInset, right: 0)
        
        //Setup Person
        self.title = person.name
        titleView.text = person.name
        nameLabel.text = person.name
        
        let imageURL = self.person.profileImageURL
        personImageView.setRemoteImage(withURL: imageURL, placeholder: .asset(.PersonPlaceholder))
    }
    
    fileprivate func setupDataSource() {
        dataSource = PersonDetailDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            guard let self else { fatalError() }
            
            return self.dataSource.cell(for: collectionView, with: indexPath, identifier: item)
        })
        
        dataSource.overviewExpandAction = { [unowned self] in
            UIView.transition(with: self.collectionView, duration: 0.2, options: .transitionCrossDissolve) {
                self.dataSource.reloadOverviewSection()
            }
        }
        
        dataSource.openSocialLink = { socialLink in
            UIApplication.shared.open(socialLink.url)
        }
    
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
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError()
            }
            .store(in: &cancellables)

        store.refresh()
    }
    
    //MARK: - Actions
    fileprivate func storeDidUpdate() {
        dataSource.person = store.person
        dataSource.isLoading = store.isLoading
        UIView.transition(with: self.collectionView, duration: 0.2, options: .transitionCrossDissolve) {
            self.dataSource.reload(force: true, animated: false)
        }

        if let indexPath = dataSource.indexPathForSelectedCreditSection {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    fileprivate func handleError() {
        router?.handle(error: .refreshError, shouldDismiss: true)
    }
    
}

//MARK: - Header Animations
extension PersonDetailViewController {
    fileprivate func animateTitleView(show: Bool) {
        UIView.animate(withDuration: show ? 0.15 : 0.2, delay: 0) {
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
    }
    
    fileprivate func setupBlurAnimator() {
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
        if offset > threshold - 10 {
            showingNavBarTitle = true
        } else if offset < threshold + titleHeight + 30 {
            showingNavBarTitle = false
        }

        //Set blur animation progress
        var ratio: CGFloat
        ratio = 1 - newHeight / (headerHeight * 0.75)
        blurAnimator.fractionComplete = ratio
        
        let alpha = (newHeight - topInset - 5) / (headerHeight * 0.5)
        nameLabel.alpha = alpha

        //Adjust header size
        if offset < -threshold {
            headerHeightConstraint.constant = newHeight
            let bottomInset = UIWindow.mainWindow.bottomInset
            collectionView.scrollIndicatorInsets  = UIEdgeInsets(top: max(newHeight, headerHeight), left: 0, bottom: bottomInset, right: 0)

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
        case .creditCategories:
            selectCategory(at: indexPath)
        default:
            break
        }
        
    }
    
    fileprivate func selectCategory(at newIndexPath: IndexPath) {
        //Deselect other cells
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems.filter { $0.section == newIndexPath.section }
        for indexPath in visibleIndexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                cell.setSelection(false)
            }
        }
        
        //Select new cell
        let cell = collectionView.cellForItem(at: newIndexPath) as? CategoryCell
        cell?.setSelection(true)
        
        //Scroll to last item of new section if current section has more items
        if let creditsSection = dataSource.sectionForCredits,
           let lasVisibleIndexPath = collectionView.indexPathsForVisibleItems.filter({ $0.section == creditsSection }).sorted().last {
            let newCount = dataSource.itemCount(for: dataSource.creditSections[newIndexPath.row])
            if lasVisibleIndexPath.row > newCount {
                collectionView.scrollToItem(at: IndexPath(row: newCount, section: creditsSection),
                                            at: .bottom,
                                            animated: true)
            }
        }
        
        dataSource.selectedCreditSection = dataSource.creditSections[newIndexPath.row]
        dataSource.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let categoryCell = cell as? CategoryCell {
            categoryCell.setSelection(indexPath == dataSource.indexPathForSelectedCreditSection)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == SectionBackgroundDecorationView.elementKind, let bgView = view as? SectionBackgroundDecorationView {
            bgView.backgroundColor = .systemGray6
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
    
}
