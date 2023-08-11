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
    
    var collectionView: UICollectionView!
    var dataSource: PersonDetailDataSource!
    
    weak var headerView: PersonHeaderView!
    
    var store: PersonDetailStore!
    var person: PersonViewModel! {
        store.person
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var titleView = UILabel()
    var titleViewTopConstraint: NSLayoutConstraint!
    
    private var imageHeight: CGFloat {
        UIWindow.mainWindow.frame.width * 1.5
    }
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        setup()
        setupTitleView()
        setupDataSource()
        setupStore()
        setupCustomBackButton()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Bar Appearance
    override func viewWillAppear(_ animated: Bool) {
        configureWithTransparentNavigationBarAppearance()
    }
    
    //MARK: - Setup
    fileprivate func createCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.anchor(to: view)
    }
    
    fileprivate func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in            
            let section = dataSource.sections[sectionIndex]
            return PersonDetailLayoutProvider.layout(for: section)
        }
        
        layout.configuration = CompositionalLayoutBuilder.createGlobalHeaderConfiguration(height: .estimated(500), kind: PersonHeaderView.headerkind, pinToVisibleBounds: true)
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        return layout
    }
    
    fileprivate func setup() {
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.delegate = self
        
        //Setup CollectionView
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        collectionView.contentInset.bottom = UIWindow.mainWindow.bottomInset

        //Set so the scrollIndicator stops before the status bar
        collectionView.verticalScrollIndicatorInsets.top = UIWindow.mainWindow.topInset
        collectionView.verticalScrollIndicatorInsets.bottom = UIWindow.mainWindow.bottomInset
    }
    
    fileprivate func setupTitleView() {
        //Create Title
        let titleViewContainer = UIView()
        titleViewContainer.clipsToBounds = false
        titleView.font = UIFont(name: "Avenir Next Medium", size: 20)
        titleView.textColor = .label
        titleView.alpha = 0
        
        //Setup Title
        titleViewContainer.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleViewTopConstraint = titleView.topAnchor.constraint(equalTo: titleViewContainer.topAnchor, constant: 20)
        NSLayoutConstraint.activate([
            titleViewTopConstraint,
            titleView.bottomAnchor.constraint(equalTo: titleViewContainer.bottomAnchor, constant: 0),
            titleView.leadingAnchor.constraint(equalTo: titleViewContainer.leadingAnchor, constant: 0),
            titleView.trailingAnchor.constraint(equalTo:titleViewContainer.trailingAnchor, constant: 0)
        ])
        navigationItem.titleView = titleViewContainer
    }
    
    fileprivate func setupDataSource() {
        let personHeaderRegistration = UICollectionView.SupplementaryRegistration<PersonHeaderView>(supplementaryNib: PersonHeaderView.namedNib(), elementKind: PersonHeaderView.headerkind) { [unowned self] header, _, _ in
            configurePersonHeader(header: header)
        }
        
        dataSource = PersonDetailDataSource(collectionView: collectionView, supplementaryViewProvider: { [unowned self] collectionView, elementKind, indexPath in
            if elementKind == PersonHeaderView.headerkind {
                return collectionView.dequeueConfiguredReusableSupplementary(using: personHeaderRegistration, for: indexPath)
            } else {
                return dataSource.sectionTitleView(collectionView: collectionView, at: indexPath)
            }
        })
        
        dataSource.overviewExpandAction = { [unowned self] in
            UIView.transition(with: collectionView, duration: 0.2, options: .transitionCrossDissolve) {
                self.dataSource.reloadOverviewSection()
            }
        }
        
        dataSource.openSocialLink = { socialLink in
            UIApplication.shared.open(socialLink.url)
        }
        
        dataSource.willChangeSelectedDepartment = { [unowned self] department in
            updateInsets(for: department)
        }
    }
    
    fileprivate func configurePersonHeader(header: PersonHeaderView) {
        header.headerHeightConstraint.constant = imageHeight
        header.imageHeightConstraint.constant = imageHeight
        
        //Setup Person
        title = person.name
        titleView.text = person.name
        header.nameLabel.text = person.name
        
        let imageURL = person.profileImageURL
        header.personImageView.setRemoteImage(withURL: imageURL, placeholder: .asset(.PersonPlaceholder))
        
        self.headerView = header
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
    }
    
    fileprivate func handleError() {
        router?.handle(error: .refreshError, shouldDismiss: true)
    }
    
    fileprivate func updateInsets(for selectedDepartment: String) {
        let safeAreaBottom = view.safeAreaInsets.bottom
        let safeAreaTop = view.safeAreaInsets.top
        
        let departmentsSectionHeight: CGFloat =
        PersonDetailLayoutProvider.departmentsTitleHeight +
        PersonDetailLayoutProvider.departmentsCellHeight +
        PersonDetailLayoutProvider.departmentsTopPadding +
        PersonDetailLayoutProvider.departmentsBottomPadding
        
        let targetHeight = view.frame.size.height - safeAreaTop - departmentsSectionHeight
        
        let creditCellHeight: CGFloat = PersonDetailLayoutProvider.creditCellHeight
        let newCount = person.credits(for: selectedDepartment).count
        let newSectionHeight = creditCellHeight * CGFloat(newCount)
        
        collectionView.showsVerticalScrollIndicator = false //Hide indicator to avoid jump when setting offset and inset
        let contentOffset = collectionView.contentOffset
        if newSectionHeight < targetHeight {
            collectionView.contentInset.bottom = targetHeight - newSectionHeight
        } else {
            collectionView.contentInset.bottom = safeAreaBottom
        }
        collectionView.setContentOffset(contentOffset, animated: false) //Restore offset to avoid jump when setting inset
        collectionView.showsVerticalScrollIndicator = true //Restore indicators after setting offset
    }
    
    //MARK: - Header Animations
    fileprivate var showingNavBarTitle = false
    
    fileprivate func animateTitleView(show: Bool) {
        if show == showingNavBarTitle { return }
        
        showingNavBarTitle = show
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
    
    fileprivate func updateHeader() {
        let offset = collectionView.contentOffset.y
        
        //Stretch image if pulled down
        if offset <= 0 {
            headerView.topImageConstraint.constant = offset
            headerView.imageHeightConstraint.constant = imageHeight + abs(offset)
            return
        }
        
        let navBarHeight = view.safeAreaInsets.top
        let threshold = imageHeight - navBarHeight
        let nameLabelThreshold = headerView.nameLabel.frame.height + 30
        
        //Adjust header image size
        let newHeight = max(imageHeight - offset, navBarHeight)
        headerView.imageHeightConstraint.constant = newHeight

        //Animate title
        if offset > threshold - 10 {
            animateTitleView(show: true)
        } else if offset < threshold + nameLabelThreshold {
            animateTitleView(show: false)
        }

        //Set blur animation progress
        let ratio: CGFloat = 1 - newHeight / (imageHeight * 0.75)
        headerView.blurAnimator.fractionComplete = ratio

        //Set name opacity
        let alpha = (newHeight - navBarHeight - 5) / (imageHeight * 0.5)
        headerView.nameLabel.alpha = alpha
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
        case .credits:
            if let credit = dataSource.credit(at: indexPath),
               let movie = credit.movie {
                router?.showMovieDetail(movie: movie)
            }
        default:
            break
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
