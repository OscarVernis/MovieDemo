//
//  YoutubeVideoCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class YoutubeVideoCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    

    func configure(video: MovieVideoViewModel) {
        titleLabel.text = video.type
        videoImageView.af.setImage(withURL: video.thumbnailURLForYoutubeVideo, imageTransition: .crossDissolve(0.3))
    }

}
