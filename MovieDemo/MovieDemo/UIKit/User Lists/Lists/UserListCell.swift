//
//  UserListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        containerView.backgroundColor = selected ? .systemGray2 : .systemGray6
    }

}
