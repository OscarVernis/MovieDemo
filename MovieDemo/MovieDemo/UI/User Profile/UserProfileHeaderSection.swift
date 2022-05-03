//
//  UserProfileHeaderSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileHeaderSection: ConfigurableSection {
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    let user: UserViewModel
    
    var isLoading = false
    
    var logoutButtonHandler: (()->Void)?
    
    init(user: UserViewModel) {
        self.user = user
    }

    var itemCount: Int {
        return (isLoading == true) ? 1 : 0
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        UserProfileHeaderView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()

        let section = sectionBuilder.createSection(groupHeight: .estimated(150))
        
        let sectionHeader = sectionBuilder.createDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeaderView.reuseIdentifier, for: indexPath) as! UserProfileHeaderView
        
        //Adjust the top of the Poster Image so it doesn't go unde the bar
        headerView.topConstraint.constant = topInset + 55
        headerView.logoutButtonHandler = logoutButtonHandler
        
        headerView.configure(user: user)
        
        return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
        
        return cell
    }
    
}


