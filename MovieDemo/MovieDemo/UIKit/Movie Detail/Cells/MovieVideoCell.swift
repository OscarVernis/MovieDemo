//
//  MovieVideoCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieVideoCell: UICollectionViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)!
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        
        return label
    }()
    
    var youtubeView: UIYoutubeView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.anchor(bottom: contentView.bottomAnchor,
                          leading: contentView.leadingAnchor, paddingLeading: 5,
                          trailing: contentView.trailingAnchor)
        
        youtubeView = UIYoutubeView()
        youtubeView.setupBorder()
        youtubeView.layer.cornerRadius = 12
        youtubeView.layer.masksToBounds = true

        contentView.addSubview(youtubeView)
        youtubeView.anchor(top: contentView.topAnchor,
                           bottom: titleLabel.topAnchor, paddingBottom: 8,
                           leading: contentView.leadingAnchor,
                           trailing: contentView.trailingAnchor)
        
        NSLayoutConstraint.activate([youtubeView.heightAnchor.constraint(equalTo: youtubeView.widthAnchor, multiplier: 9/16)])
    }

    override func prepareForReuse() {
        youtubeView.previewImageURL = nil
        youtubeView.youtubeURL = nil
    }
    
    func setupYoutubeView(previewURL: URL?, youtubeURL: URL) {
        youtubeView.previewImageURL = previewURL
        youtubeView.youtubeURL = youtubeURL
    }
}

//MARK: - Configure
extension MovieVideoCell {
    static func configure(cell: MovieVideoCell, video: MovieVideoViewModel) {
        cell.setupYoutubeView(previewURL: video.thumbnailURL, youtubeURL: video.trailerURL)
        cell.titleLabel.text = video.name
    }
}
