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
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
                
        createViews()
        setup()
        setupDataSource()
        setupStore()
        setupCustomBackButton()
        setupTitleView()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Bar Appearance
    override func viewWillAppear(_ animated: Bool) {
        configureWithTransparentNavigationBarAppearance()
    }
    
    //MARK: - Setup
    fileprivate func createViews() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.anchor(to: view)
        
        headerView = PersonHeaderView.instantiateFromNib()
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
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
        //Setup CollectionView
        collectionView.delegate = self
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        let width = UIWindow.mainWindow.frame.width
        let height = width * 1.5
        let bottomInset = UIWindow.mainWindow.bottomInset
        headerView.headerHeightConstraint.constant = height
        collectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: bottomInset, right: 0)
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: height, left: 0, bottom: bottomInset, right: 0)
        
        //Setup Person
        self.title = person.name
        titleView.text = person.name
        headerView.nameLabel.text = person.name
        
        let imageURL = self.person.profileImageURL
        headerView.personImageView.setRemoteImage(withURL: imageURL, placeholder: .asset(.PersonPlaceholder))
    }
    
    fileprivate func setupDataSource() {
        dataSource = PersonDetailDataSource(collectionView: collectionView)
        
        dataSource.overviewExpandAction = { [unowned self] in
            UIView.transition(with: self.collectionView, duration: 0.2, options: .transitionCrossDissolve) {
                self.dataSource.reloadOverviewSection()
            }
        }
        
        dataSource.openSocialLink = { socialLink in
            UIApplication.shared.open(socialLink.url)
        }
        
        dataSource.willChangeSelectedDepartment = { [unowned self] department in
            self.updateScrollPosition(with: department)
        }
    }
    
    fileprivate func updateScrollPosition(with department: String) {
        let safeAreaBottom = view.safeAreaInsets.bottom
        let safeAreaTop = view.safeAreaInsets.top
        
        let departmentsSectionHeight: CGFloat =
        PersonDetailLayoutProvider.departmentsTitleHeight +
        PersonDetailLayoutProvider.departmentsCellHeight +
        PersonDetailLayoutProvider.departmentsTopPadding +
        PersonDetailLayoutProvider.departmentsBottomPadding
        
        let targetHeight = view.frame.size.height - safeAreaTop - departmentsSectionHeight
        
        let creditCellHeight: CGFloat = PersonDetailLayoutProvider.creditCellHeight
        let newCount = person.credits(for: department).count
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
    
    //MARK: - Header Animations
    fileprivate var showingNavBarTitle = false
    
    fileprivate func animateTitleView(show: Bool) {
        if show == showingNavBarTitle { return }
        
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
            animateTitleView(show: true)
        } else if offset < threshold + titleHeight + 30 {
            animateTitleView(show: false)
        }

        //Set blur animation progress
        var ratio: CGFloat
        ratio = 1 - newHeight / (headerHeight * 0.75)
        headerView.blurAnimator.fractionComplete = ratio
        
        let alpha = (newHeight - topInset - 5) / (headerHeight * 0.5)
        headerView.nameLabel.alpha = alpha

        //Adjust header size
        if offset < -threshold {
            headerView.headerHeightConstraint.constant = newHeight
            let bottomInset = UIWindow.mainWindow.bottomInset
            collectionView.scrollIndicatorInsets  = UIEdgeInsets(top: max(newHeight, headerHeight), left: 0, bottom: bottomInset, right: 0)
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
//       print(collectionView.contentOffset.y)
        updateHeader()
    }
    
}
