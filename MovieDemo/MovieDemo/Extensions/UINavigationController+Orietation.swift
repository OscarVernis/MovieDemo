//
//  UINavigationController+Orietation.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 02/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController: UINavigationControllerDelegate {
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return navigationController.topViewController?.supportedInterfaceOrientations ?? .all
    }
    
    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return .portrait
    }
    
    
}
