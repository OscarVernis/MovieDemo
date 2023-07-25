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
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.isHidden = true
    }
    
    override func prepareForReuse() {
        imageView.superview?.isHidden = true
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

//MARK: - Configure
extension SectionTitleView {
    static func configureForHome(headerView: SectionTitleView, title: String, image: UIImage? = nil) {
        headerView.titleLabel.text = title
        
        headerView.imageView.image = image
        headerView.imageView.superview?.isHidden = (image == nil)
    }
    
    static func configureForDetail(headerView: SectionTitleView, title: String, image: UIImage? = nil) {
        headerView.titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)!
        
        configureForHome(headerView: headerView, title: title, image: image)
    }
    
}
