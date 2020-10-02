//
//  Animator.swift
//  MediaViewer
//
//  Created by Oscar Vernis on 30/09/20.
//

import UIKit

class MediaViewerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let transitionDuration = 0.6
    var originView: UIView?
    
    init(isPresenting: Bool, presentFrom view: UIView? = nil) {
        self.isPresenting = isPresenting
        self.originView = view
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresenting(using: transitionContext)
        } else {
            animateDismissing(using: transitionContext)
        }
        
    }
    
    func animatePresenting(using transitionContext: UIViewControllerContextTransitioning) {
        guard let mediaViewer = transitionContext.viewController(forKey: .to) as? MediaViewerViewController else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(mediaViewer.view!)
        
        //Don't animate ImageView if there isn't an image
        let animateImageView: Bool = mediaViewer.imageView.image != nil

        //Fade in Background
        mediaViewer.view.backgroundColor = .clear
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            mediaViewer.view.backgroundColor = .black
        } completion: { finished in
            if !animateImageView {
                transitionContext.completeTransition(true)
            }
        }
        
        //Animate ImageView
        originView?.alpha = 0
        if animateImageView {
            let originalFrame = mediaViewer.imageView.frame
            //Animate from origin view or from center if there's not an origin view
            if let originView = originView {
                let initialFrame = originView.superview!.convert(originView.frame, to: containerView)
                mediaViewer.imageView.frame = initialFrame
            } else {
                mediaViewer.imageView.frame =  mediaViewer.imageView.frame.applying(CGAffineTransform(scaleX: 0.2, y: 0.2))
                mediaViewer.imageView.center = mediaViewer.view.center
            }
            
            UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 20, options: []) {
                mediaViewer.imageView.frame = originalFrame
            } completion: { finished in
                transitionContext.completeTransition(true)
            }
        }
        
    }
    
    func animateDismissing(using transitionContext: UIViewControllerContextTransitioning) {
        guard let mediaViewer = transitionContext.viewController(forKey: .from) as? MediaViewerViewController else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(mediaViewer.view!)
        
        let animateContentView: Bool = mediaViewer.contentView != nil
        
        //Fade out Background
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            mediaViewer.view.backgroundColor = .clear
        } completion: { finished in
            if !animateContentView {
                transitionContext.completeTransition(true)
                self.originView?.alpha = 1
            }
        }
        
        if animateContentView { //Animate ContentView
            let transformToOrigingView: Bool = originView != nil
            
            UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, options: []) {
                if transformToOrigingView {
                    mediaViewer.contentView?.transform = .identity
                    
                    let originFrame = self.originView!.superview!.convert(self.originView!.frame, to: containerView)
                    mediaViewer.contentView?.frame = originFrame
                    mediaViewer.contentView?.layer.cornerRadius = self.originView!.layer.cornerRadius
                    
                    if mediaViewer.contentView is MediaViewerPlayerView {
                        mediaViewer.contentView?.alpha = 0
                        self.originView?.alpha = 1
                    }
                } else {
                    mediaViewer.contentView?.transform = mediaViewer.imageView.transform.scaledBy(x: 0.2, y: 0.2)
                    mediaViewer.contentView?.alpha = 0
                }
            } completion: { finished in
                transitionContext.completeTransition(true)
                self.originView?.alpha = 1
            }
        }
        
    }
    
}
