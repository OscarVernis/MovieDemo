//
//  UserProfileViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    weak var mainCoordinator: MainCoordinator!
    
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    private var bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    
    enum Section: Int, CaseIterable {
        case Header
        case Favorites
        case Watchlist
        case Rated
        
        var title: String {
            switch self {
            case .Header:
                return ""
            case .Favorites:
                return "Favorites"
            case .Watchlist:
                return "Watchlist"
            case .Rated:
                return "Rated"
            }
        }
        
    }
    
    private var sections: [Section]!
    private var isLoading = true
    
    private var user = UserViewModel()
    private var collectionView: UICollectionView!
    
    //MARK:- Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            .Header,
        ]
        
        setupCollectionView()
        setupDataProvider()
        
    }
    
    fileprivate func reloadSections() {
        sections.removeAll()
        sections.append(.Header)
        
        if user.favorites.count > 0 {
            sections.append(.Favorites)
        }
        
        if user.watchlist.count > 0 {
            sections.append(.Watchlist)
        }
        
        if user.rated.count > 0 {
            sections.append(.Rated)
        }
        
        isLoading = false
        collectionView.reloadData()
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(named: "AppBackgroundColor")
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Set NavigationBar/ScrollView settings for design
        self.navigationItem.largeTitleDisplayMode = .always
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        
        //Load Background Blur View
//        if let imageURL = movie.posterImageURL(size: .w342) {
//            collectionView.backgroundColor = .clear
//
//            let bgView = BlurBackgroundView.namedNib().instantiate(withOwner: nil, options: nil).first as! BlurBackgroundView
//
//            bgView.imageView.af.setImage(withURL: imageURL)
//            collectionView.backgroundView = bgView
//        }
        
        //Register Cells and Headers
        UserProfileHeaderView.registerHeader(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(withCollectionView: collectionView)
        MoviePosterInfoCell.register(withCollectionView: collectionView)
        
        collectionView.collectionViewLayout = createLayout()
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
        
        user.didUpdate = updateCollectionView
        user.updateUser()
    }
    
}

//MARK: - CollectionView CompositionalLayout
extension UserProfileViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section: NSCollectionLayoutSection?
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            let sectionType = self?.sections[sectionIndex]
            
            switch sectionType {
            case .Header: //This is a dummy section used to contain the main header, it will not display any items
                section = sectionBuilder.createEmptySection(withHeight: 150)
                
                let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Favorites:
                section = sectionBuilder.createHorizontalPosterSection()
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.contentInsets.top = 12
                section?.contentInsets.bottom = 10
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Watchlist:
                section = sectionBuilder.createHorizontalPosterSection()
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.contentInsets.top = 12
                section?.contentInsets.bottom = 10
                section?.boundarySupplementaryItems = [sectionHeader]
                
            case .Rated:
                section = sectionBuilder.createHorizontalPosterSection()
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.contentInsets.top = 12
                section?.contentInsets.bottom = 10
                section?.boundarySupplementaryItems = [sectionHeader]
            case .none:
                break
            }
            return section
        }
        
        return layout
    }
    
}

// MARK: UICollectionViewDelegate
extension UserProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header:
            break
        case .Favorites:
            let movie = user.favorites[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
            break
        case .Watchlist:
            let movie = user.watchlist[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
            break
        case .Rated:
            let movie = user.rated[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
            break
        }
    }
}

// MARK: UICollectionViewDataSource
extension UserProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = self.sections[section]
        switch sectionType {
        case .Header:
            return isLoading ? 1 : 0 //Dummy section to show Header, if loading shows LoadingCell
        case .Favorites:
            return user.favorites.count
        case .Watchlist:
            return user.watchlist.count
        case .Rated:
            return user.rated.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header:
            if isLoading {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
                
                return cell
            } else {
                fatalError("Should be empty!")
            }
        case .Favorites:
            let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
            
            let movie = user.favorites[indexPath.row]
            
            MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))
            
            return posterCell
        case .Watchlist:
            let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
            
            let movie = user.watchlist[indexPath.row]
            
            MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))
            
            return posterCell
        case .Rated:
            let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
            
            let movie = user.rated[indexPath.row]
            
            MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))
            
            return posterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = self.sections[indexPath.section]
        
        if sectionType == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeaderView.reuseIdentifier, for: indexPath) as! UserProfileHeaderView
            
            //Adjust the top of the Poster Image so it doesn't go unde the bar
//            headerView.topConstraint.constant = topInset + 55
//            headerView.imageTapHandler = { [weak self] in
//                guard let self = self else { return }
//
//                self.showImage()
//            }
            
            headerView.configure(user: user)
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            var tapHandler: (() -> ())?
            switch sectionType {
            case .Header:
                break
            case .Favorites:
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: StaticArrayDataProvider(models: self.user.favorites))
                }
            case .Watchlist:
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: StaticArrayDataProvider(models: self.user.watchlist))

                }
            case .Rated:
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: StaticArrayDataProvider(models: self.user.rated))
                }
            }
            
            MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: sectionType.title, tapHandler: tapHandler)
            
            return headerView
        }
    }

}
