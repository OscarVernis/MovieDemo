//
//  UserProfileHeaderView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UICollectionReusableView {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var logoutButtonHandler: (()->Void)? = nil
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logoutButtonHandler?()
    }
    
    func configure(user: UserViewModel) {
        if let url = user.avatarURL {
            userImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        usernameLabel.text = user.username
    }
}
