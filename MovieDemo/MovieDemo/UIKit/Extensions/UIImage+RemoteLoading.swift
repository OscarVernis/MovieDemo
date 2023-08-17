//
//  UIImage+RemoteLoading.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImage {
    static func loadRemoteImage(url: URL, completion: ((UIImage?) -> ())? = nil) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            if case let .success(image) = result {
                completion?(image.image)
            }
        }
    }
    
}
