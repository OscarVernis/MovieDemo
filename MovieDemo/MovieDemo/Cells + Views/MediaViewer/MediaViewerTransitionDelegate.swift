//
//  MediaViewerTransitionDelegate.swift
//  MediaViewer
//
//  Created by Oscar Vernis on 30/09/20.
//

import UIKit

class MediaViewerTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var fromView: UIView?

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return MediaViewerAnimator(isPresenting: true, presentFrom: fromView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return MediaViewerAnimator(isPresenting: false, presentFrom: fromView)
    }
}
