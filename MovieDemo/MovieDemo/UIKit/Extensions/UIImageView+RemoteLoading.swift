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
    func setRemoteImage(withURL url: URL, animated: Bool = false, completion: (() -> ())? = nil) {
        self.sd_imageTransition = animated ? .fade : .none
        self.sd_setImage(with: url) { _,_,_,_ in
            completion?()
        }
    }
    
    func cancelImageRequest() {
        self.sd_cancelCurrentImageLoad()
    }
    
}
