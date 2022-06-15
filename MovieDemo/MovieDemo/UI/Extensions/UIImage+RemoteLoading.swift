//
//  UIImage+RemoteLoading.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImage {
    static func loadRemoteImage(url: URL, completion: ((UIImage?) -> ())? = nil) {
        SDWebImageManager.shared.loadImage(with: url, progress: nil) { image, _, _, _, _, _ in
            completion?(image)
        }
    }
    
}
