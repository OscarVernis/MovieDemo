//
//  YoutubeCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class TrailerCell: UICollectionViewCell {
    var youtubeURL: URL? = nil

    @IBAction func openVideo(_ sender: Any) {
        if let url = youtubeURL {
            print(url)
            UIApplication.shared.open(url)
        }
    }

}
