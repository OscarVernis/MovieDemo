//
//  WhereToWatchCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class WhereToWatchCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!
    var buttonAction: (() -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()

        button.configuration?.image = button.configuration?.image?.withAlignmentRectInsets(UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0))
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    private func buttonTapped() {
        buttonAction?()
    }

}
