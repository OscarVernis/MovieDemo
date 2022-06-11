//
//  SectionTitleView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class SectionTitleView: UICollectionReusableView {        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.isHidden = true
    }

    var tapHandler: (() -> ())? = nil {
        didSet {
            //Hide button if there's no Handler
            actionButton.isHidden = tapHandler == nil
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        tapHandler?()
    }
}
