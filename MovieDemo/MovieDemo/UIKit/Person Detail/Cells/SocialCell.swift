//
//  SocialCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 31/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class SocialCell: UICollectionViewCell {
    @IBOutlet weak var stackView: UIStackView!
    var socialLinks: [SocialLink] = [] {
        didSet {
            update()
        }
    }
    var didSelect: ((SocialLink) -> ())?

    private func update() {
        for view in stackView.subviews {
            view.removeFromSuperview()
        }
        
        for link in socialLinks {
            let button = UIButton()
            
            let image = image(for: link)
            button.setImage(image, for: .normal)
            button.contentHorizontalAlignment = .leading
            button.tintColor = .label
            
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            let action = UIAction { [weak self] _ in
                self?.didSelect?(link)
            }
            button.addAction(action, for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
        
    }

    
    private func image(for socialLink: SocialLink) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 27)
        
        switch socialLink {
        case .imdb:
            return UIImage(systemName: "film")!.withConfiguration(config)
        case .facebook:
            return UIImage(named: "facebook")!.withConfiguration(config)
        case .instagram:
            return UIImage(named: "instagram")!.withConfiguration(config)
        case .tiktok:
            return UIImage(named: "tiktok")!.withConfiguration(config)
        case .twitter:
            return UIImage(named: "twitter")!.withConfiguration(config)
        case .youtube:
            return UIImage(named: "youtube")!.withConfiguration(config)
        case .homepage:
            let linkConfig = UIImage.SymbolConfiguration(pointSize: 23)
            return UIImage(systemName: "link")!.withConfiguration(linkConfig)
        }
    }

}
