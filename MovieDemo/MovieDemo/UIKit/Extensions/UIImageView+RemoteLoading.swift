//
//  UIImageView+RemoteLoading.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setRemoteImage(withURL url: URL?, placeholder: UIImage? = nil, animated: Bool = true, completion: (() -> ())? = nil) {
        guard let url else { return }
        
        self.sd_imageTransition = animated ? .fade(duration: 0.2) : .none
        self.sd_setImage(with: url, placeholderImage: placeholder) { _,_,_,_ in
            completion?()
        }
    }
    
    func cancelImageRequest() {
        self.sd_cancelCurrentImageLoad()
    }
    
}
