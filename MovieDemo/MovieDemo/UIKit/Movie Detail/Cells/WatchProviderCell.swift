//
//  WatchProviderCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class WatchProviderCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.cancelImageRequest()
    }
}

extension WatchProviderCell {
    static func configure(cell: WatchProviderCell, provider: WatchProvider) {
        cell.providerLabel.text = provider.providerName
        
        let url = MovieServiceImageUtils.watchProviderImageURL(forPath: provider.logoPath)
        cell.imageView.setRemoteImage(withURL: url)
    }
    
}
