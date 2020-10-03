//
//  MediaViewerViewController.swift
//  MediaViewer
//
//  Created by Oscar Vernis on 30/09/20.
//

import UIKit
import AVKit
import AlamofireImage

final class MediaViewerViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var contentView: UIView?
    var imageView: UIImageView!
    var videoPlayerView: MediaViewerPlayerView!
    var videoControls: MediaViewerPlayerControls?
    private var zoomScrollView: UIScrollView!
    private var activityIndicator: UIActivityIndicatorView!
    private var closeButton: UIButton!
    
    private var image: UIImage?
    private var imageURL: URL?
    var videoURL: URL?
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    private var controlsTimer: Timer?
    private var isShowingVideoControls: Bool = false {
        didSet {
            setVisibleControls(isShowingVideoControls)
        }
    }
    
    private let transitionDelegate: MediaViewerTransitionDelegate
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior?
    
    private var playerLayerKVO: NSKeyValueObservation?
    
    //MARK:- ViewController
    
    init(videoURL: URL? = nil, imageURL: URL? = nil, image: UIImage? = nil, presentFromView view: UIView? = nil) {
        self.videoURL = videoURL
        self.image = image
        self.imageURL = imageURL
        transitionDelegate = MediaViewerTransitionDelegate()
        super.init(nibName: nil, bundle: nil)
        
        //ViewController
        modalPresentationStyle = .custom
        transitionDelegate.fromView = view
        transitioningDelegate = transitionDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createViews()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setCloseButtonVisible(false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { [unowned self] _ in
            resetContentView(size: size)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        playerLayerKVO?.invalidate()
    }
    
    //MARK:- Setup
    fileprivate func createViews() {
        //Create ScrollView
        zoomScrollView = UIScrollView(frame: view.bounds)
        zoomScrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        zoomScrollView.delegate = self
        zoomScrollView.maximumZoomScale = 2.0
        zoomScrollView.showsHorizontalScrollIndicator = false
        zoomScrollView.showsVerticalScrollIndicator = false
        view.addSubview(zoomScrollView)
        
        //Create ImageView
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        zoomScrollView.addSubview(imageView)
        
        //Create ActivityIndicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        //Create PlayerView
        if let videoURL = videoURL {
            videoPlayerView = MediaViewerPlayerView(url: videoURL)
            videoPlayerView.frame = view.bounds
            videoPlayerView.alpha = 0
            zoomScrollView.addSubview(videoPlayerView)
            
            videoControls =  (UINib(nibName: "MediaViewerPlayerControls", bundle: .main).instantiate(withOwner: nil, options: nil).first as! MediaViewerPlayerControls)
            videoControls!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(videoControls!)
            videoControls!.alpha = 0
            
            NSLayoutConstraint.activate([
                videoControls!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
                videoControls!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                videoControls!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                videoControls!.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            isLoading = true
        }
        
        //Close Button
        closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        closeButton.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
    }
    
    fileprivate func setup() {
        //ViewController
        overrideUserInterfaceStyle = .dark
        modalPresentationCapturesStatusBarAppearance = true
        
        //GestureRecognizers
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleAttachmentGesture))
        panRecognizer.delegate = self
        view.addGestureRecognizer(panRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
        
        tapRecognizer.require(toFail: doubleTapRecognizer)
        
        //ImageViewLoading
        if image != nil {
            imageView.image = image
            contentView = imageView
            resetContentView()
        }
        
        if let url = imageURL {
            if image == nil {
                isLoading = true
            }
            
            imageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3), completion: { [weak self] response in
                self?.isLoading = false
                self?.contentView = self?.imageView
                self?.resetContentView()
            })
        }
        
        //Extra setup
        animator = UIDynamicAnimator(referenceView: view)
        
        //Video Setup
        if videoPlayerView != nil {
            playerLayerKVO = videoPlayerView.playerLayer.observe(\.isReadyForDisplay) { [weak self] playerLayer, change in
                self?.startPlayingVideo()
            }
        }
        
    }
    
    fileprivate func reset() {
        animator.removeAllBehaviors()
        if videoControls == nil {
            setCloseButtonVisible(true)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.view.backgroundColor = .black
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 30) {
            self.resetContentView()
            self.imageView.transform = .identity
        }
    }
    
    fileprivate func resetContentView(size: CGSize? = nil) {
        guard let contentView = contentView else { return }
        
        let contentViewFrame: CGRect
        let maxZoom: CGFloat
        
        //Size is sent before changing view size (changing orientation), otherwise use current view frame
        let viewFrame: CGRect
        if let size = size {
            viewFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        } else {
            viewFrame = view.bounds
        }
        
        if contentView == videoPlayerView {
            let contentSize = videoPlayerView.playerLayer.videoRect.size
            contentViewFrame = AVMakeRect(aspectRatio: contentSize, insideRect: viewFrame)
            maxZoom = zoomScaleForVideo(size: contentSize)
        } else {
            guard contentView == imageView, let newImage = imageView.image else { return }
            
            let contentSize = newImage.size
            contentViewFrame = AVMakeRect(aspectRatio: contentSize, insideRect: viewFrame)
            maxZoom = max((newImage.size.width * newImage.scale) / viewFrame.width, 2.0)
        }

        contentView.bounds = contentViewFrame
        contentView.center = CGPoint(x: viewFrame.midX, y: viewFrame.midY)
        
        zoomScrollView.maximumZoomScale = maxZoom
        zoomScrollView.zoomScale = zoomScrollView.minimumZoomScale
        
    }
    
    func zoomScaleForVideo(size: CGSize) -> CGFloat {
        let aspectRatio = AVMakeRect(aspectRatio: size, insideRect: view.frame)
        let horizontalRatio = view.frame.width / aspectRatio.width;
        let verticalRatio = view.frame.height / aspectRatio.height;
        
        let scale = max(horizontalRatio, verticalRatio)
        
        return scale
    }
    
    //MARK:- Video Handling
    fileprivate func startPlayingVideo() {
        isLoading = false
        
        videoControls?.player = videoPlayerView.player
        
        contentView = videoPlayerView
        resetContentView()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.videoControls?.transportSlider.addTarget(self, action: #selector(self.transportSliderStoppedTracking), for: [.touchUpInside, .touchUpOutside])
            self.videoControls?.alpha = 1
            self.isShowingVideoControls = true

            self.videoPlayerView.alpha = 1
            self.imageView.alpha = 0
        } completion: { _ in
            self.videoPlayerView.play()
            self.setupVideoControlsTimer()
        }

    }
    
    fileprivate func setupVideoControlsTimer() {
        controlsTimer?.invalidate()

        controlsTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] timer in
            self?.isShowingVideoControls = false
        })
    }
    
    @objc fileprivate func transportSliderStoppedTracking() {
        setupVideoControlsTimer()
    }
    
    fileprivate func setCloseButtonVisible(_ visible: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [(visible ? .curveEaseIn : .curveEaseOut), .beginFromCurrentState]) {
            self.closeButton.alpha = visible ? 1 : 0
        }
    }
    
    fileprivate func setVisibleControls(_ visible: Bool) {
        if let videoControls = videoControls, videoControls.transportSlider.isTracking {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [(visible ? .curveEaseIn : .curveEaseOut), .beginFromCurrentState]) {
            self.videoControls?.alpha = visible ? 1 : 0
            self.closeButton.alpha = visible ? 1 : 0
        }

    }
    
    //MARK:- Actions
    @objc fileprivate func close(sender: UIButton) {
        if zoomScrollView.zoomScale > zoomScrollView.minimumZoomScale {
            zoomScrollView.setZoomScale(zoomScrollView.minimumZoomScale, animated: false)
        }
        
        setVisibleControls(false)
        dismiss(animated: true)
    }
        
    //MARK:- Gesture Handlers
    @IBAction fileprivate func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
        guard isLoading == false, zoomScrollView.zoomScale <= zoomScrollView.minimumZoomScale, let contentView = contentView else {
            return
        }
        
        if contentView == imageView && imageView.image == nil {
            return
        }
                
        let location = sender.location(in: self.view)
        let locationInView = sender.location(in: self.contentView)
        
        switch sender.state {
        case .began:
            animator.removeAllBehaviors()
            
            let centerOffset = UIOffset(horizontal: locationInView.x - contentView.bounds.midX, vertical: locationInView.y - contentView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: contentView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            
            animator.addBehavior(attachmentBehavior!)
        case .ended:
            animator.removeAllBehaviors()
            
            let translationY = abs(sender.translation(in: view).y)
            let translationThreshold: CGFloat = 250
            let velocityThreshold: CGFloat = 1000
            let velocity = sender.velocity(in: view)
            
            if translationY > translationThreshold || abs(velocity.y) > velocityThreshold { //Dismiss view if contentView is moved or thrown above the thresholds.
                dismiss(animated: true)
            } else { //Restore view to original frame
                reset()
            }
        case .changed:
            if attachmentBehavior == nil {
                break
            }
            
            attachmentBehavior!.anchorPoint = sender.location(in: view)
                        
            let translationY = abs(sender.translation(in: view).y)
            let translationThreshold: CGFloat = 400
            let thresholdPadding: CGFloat = 50
            let percentage = (translationY - thresholdPadding) / translationThreshold
            
            if translationY > thresholdPadding {
                setVisibleControls(false)
            } else {
                if videoControls == nil {
                    setCloseButtonVisible(true)
                }
            }
            
            view.backgroundColor = UIColor.black.withAlphaComponent(1.0 - percentage)
        default:
            attachmentBehavior?.anchorPoint = sender.location(in: view)
        }
    }
    
    @objc fileprivate func handleDoubleTap(sender: UITapGestureRecognizer) {
        if zoomScrollView.zoomScale == zoomScrollView.minimumZoomScale {
            if contentView == videoPlayerView {
                zoomScrollView.setZoomScale(zoomScrollView.maximumZoomScale, animated: true)
            } else {
                let scale = zoomScrollView.maximumZoomScale
                let location = sender.location(in: contentView)
                zoomScrollView.zoom(to: zoomRectForScale(scale: scale, center: location), animated: true)
            }
        } else {
            zoomScrollView.setZoomScale(zoomScrollView.minimumZoomScale, animated: true)
        }
    }
    
    @objc fileprivate func handleTap(sender: UITapGestureRecognizer) {
        guard videoControls != nil else { return }
        controlsTimer?.invalidate()
        
        isShowingVideoControls.toggle()
        
        if isShowingVideoControls {
            setupVideoControlsTimer()
        }
                
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        guard let contentView = contentView else { return .zero }
        
        var zoomRect = CGRect.zero
        zoomRect.size.height = contentView.frame.size.height / scale
        zoomRect.size.width  = contentView.frame.size.width  / scale
        
        let newCenter = zoomScrollView.convert(center, from: contentView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    //MARK:- UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if isLoading {
            return nil
        } else {
            return contentView
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        animator.removeAllBehaviors()
        
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        // adjust the center of contentView
        contentView?.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
}
