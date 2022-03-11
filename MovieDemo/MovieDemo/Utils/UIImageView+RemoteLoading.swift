//
//  UIImageView+RemoteLoading.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func setRemoteImage(withURL url: URL, animated: Bool = true, completion: (() -> ())? = nil) {
        var afCompletion: ((AFIDataResponse<UIImage>) -> Void)? = nil
        if let completion = completion { 
            afCompletion = { response in
                completion()
            }
        }
        
        self.af.setImage(withURL: url, imageTransition: animated ? .crossDissolve(0.3) : .noTransition, completion: afCompletion)
    }
}
