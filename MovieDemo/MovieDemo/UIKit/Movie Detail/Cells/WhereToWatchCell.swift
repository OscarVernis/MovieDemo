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
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    private func buttonTapped() {
        buttonAction?()
    }

}
