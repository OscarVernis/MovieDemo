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
    @IBOutlet weak var logoutButton: CustomButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    func configure(user: UserViewModel) {
        if let url = user.avatarURL {
            userImageView.setRemoteImage(withURL: url)
        }
        
        usernameLabel.text = user.username
    }
}
