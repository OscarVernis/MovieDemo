//
//  SectionTitleView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class SectionTitleView: UICollectionReusableView {
    static let reuseIdentifier = "SectionTitleView"

    @IBOutlet weak var titleLabel: UILabel!
    var tapHandler: (() -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        tapHandler?()
    }
}
