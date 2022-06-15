//
//  UserHeaderDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

class UserHeaderDataSource: NSObject, UICollectionViewDataSource {
    let user: UserViewModel
    
    init(user: UserViewModel) {
        self.user = user
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeaderView.reuseIdentifier, for: indexPath) as! UserProfileHeaderView
        
        //Adjust the top of the Header so it doesn't go unde the bar
        headerView.topConstraint.constant = UIWindow.mainWindow.topInset + 55
        
        headerView.configure(user: user)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (user.isLoading == true) ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
    }
    
}
