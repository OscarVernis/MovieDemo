//
//  YoutubeCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class YoutubeCell: UICollectionViewCell {
    var youtubeView: YoutubeView!
    
    func setupYoutubeView(previewURL: URL?, youtubeId: String) {
        youtubeView = YoutubeView(previewURL: previewURL, youtubeId: youtubeId)

        addSubview(youtubeView)
        youtubeView.anchor(to: self)
        
        youtubeView.layer.shadowOffset = CGSize(width: 0, height: 7)
        youtubeView.layer.shadowRadius = 8
        youtubeView.layer.shadowOpacity = 0.15
    }
}
