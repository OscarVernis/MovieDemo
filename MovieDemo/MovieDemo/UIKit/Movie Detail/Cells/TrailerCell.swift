//
//  TrailerCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class TrailerCell: UICollectionViewCell {
    var youtubeView: YoutubeView!
    
    override func prepareForReuse() {
        youtubeView.removeFromSuperview()
        youtubeView = nil
    }
    
    func setupYoutubeView(previewURL: URL?, youtubeURL: URL) {
        youtubeView = YoutubeView(previewURL: previewURL, youtubeURL: youtubeURL)

        contentView.addSubview(youtubeView)
        youtubeView.anchor(to: contentView)
        
        contentView.layer.cornerRadius = 12
        
        layer.shadowOffset = CGSize(width: 0, height: 7)
        layer.shadowOpacity = 0.15
    }
}

extension TrailerCell {
    static func configure(cell: TrailerCell, with viewModel: MovieVideoViewModel) {
        cell.setupYoutubeView(previewURL: viewModel.thumbnailURLForYoutubeVideo, youtubeURL: viewModel.youtubeURL)
    }
}
