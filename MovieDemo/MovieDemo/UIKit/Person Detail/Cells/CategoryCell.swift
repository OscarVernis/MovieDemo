//
//  CategoryCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        setSelection(false)
    }
    
    func setSelection(_ selected: Bool) {
        if selected {
            titleLabel.textColor = .systemBackground
            containerView.backgroundColor = .label
            containerView.layer.borderWidth = 0
        } else {
            titleLabel.textColor = .label
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = UIColor.label.cgColor
            containerView.layer.borderWidth = 1
        }
    }

}
