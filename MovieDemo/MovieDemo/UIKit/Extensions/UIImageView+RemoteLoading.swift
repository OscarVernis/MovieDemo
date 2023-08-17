//
//  UIImageView+RemoteLoading.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setRemoteImage(withURL url: URL?, placeholder: UIImage? = nil, animated: Bool = true, completion: (() -> ())? = nil) {
        guard let url else { return }
        
        let options: KingfisherOptionsInfo? = animated ? [.transition(.fade(0.2))] : nil
        kf.setImage(with: url, placeholder: image, options: options) { result in
            if case .success(_) = result  {
                completion?()
            }
        }
    }
    
    var isLoadingRemoteImage: Bool {
        return kf.taskIdentifier != nil
    }
    
    func cancelImageRequest() {
        kf.cancelDownloadTask()
    }
    
}
