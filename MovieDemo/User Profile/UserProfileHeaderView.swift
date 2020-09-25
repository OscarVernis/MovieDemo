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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(user: UserViewModel) {
//        if let url = movie.posterImageURL(size: .w342) {
//            posterImageView.contentMode = .scaleAspectFill
//            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
//        }
        
        usernameLabel.text = user.username
    }
}
