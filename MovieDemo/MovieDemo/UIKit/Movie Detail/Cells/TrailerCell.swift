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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        youtubeView.previewImageURL = nil
        youtubeView.youtubeURL = nil
    }
    
    func setup() {
        youtubeView = YoutubeView()

        contentView.addSubview(youtubeView)
        youtubeView.anchor(to: contentView)
        
        contentView.layer.cornerRadius = 12
        
        layer.shadowOffset = CGSize(width: 0, height: 7)
        layer.shadowOpacity = 0.15
    }
    
    func setupYoutubeView(previewURL: URL?, youtubeURL: URL) {
        youtubeView.previewImageURL = previewURL
        youtubeView.youtubeURL = youtubeURL
    }
}

extension TrailerCell {
    static func configure(cell: TrailerCell, with viewModel: MovieVideoViewModel) {
        cell.setupYoutubeView(previewURL: viewModel.thumbnailURLForYoutubeVideo, youtubeURL: viewModel.youtubeURL)
    }
}
