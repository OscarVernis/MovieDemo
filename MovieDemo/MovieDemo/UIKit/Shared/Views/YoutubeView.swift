//
//  YoutubeView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine
import YouTubePlayerKit

class YoutubeView: UIView {
    var previewImageURL: URL?
    var youtubeURL: URL
    
    let buttonSize: CGFloat = 70
    
    private var hostingView: YouTubePlayerHostingView = {
        let configuration = YouTubePlayer.Configuration(autoPlay: false, playInline: false)
        return YouTubePlayerHostingView(player: YouTubePlayer(source: nil, configuration: configuration))
    }()
    
    private var previewImageView: UIImageView = {
        let imageView = UIImageView(image: .asset(.BackdropPlaceholder))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var buttonBgView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.layer.masksToBounds = true
        visualEffectView.layer.cornerRadius = buttonSize / 2
        visualEffectView.alpha = 0.9
        
        return visualEffectView
    } ()
    
    private var playButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
        button.tintColor = .white
        
        button.alpha = 0.7
        
        return button
    }()
    
    private var stateCancellable: AnyCancellable?
    private var playbackStateCancellable: AnyCancellable?

    init(previewURL: URL?, youtubeURL: URL) {
        self.previewImageURL = previewURL
        self.youtubeURL = youtubeURL
        super.init(frame: .zero)
        setup()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        backgroundColor = .asset(.SectionBackgroundColor)
        setupBorder()
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        addSubview(hostingView)
        hostingView.alpha = 0
        hostingView.anchor(to: self)
        
        addSubview(previewImageView)
        previewImageView.anchor(to: self)
        previewImageView.setRemoteImage(withURL: previewImageURL, animated: true)
        
        addSubview(buttonBgView)
        buttonBgView.anchor(width: buttonSize, height: buttonSize)
        NSLayoutConstraint.activate([
            buttonBgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonBgView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
       
        addSubview(playButton)
        playButton.anchor(to: self)
        
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
    }
    
    @objc private func play() {
        playButton.configuration?.showsActivityIndicator = true
        
        playbackStateCancellable = hostingView.player.statePublisher
            .sink(receiveValue: { [unowned self] state in
                if case let .error(error) = state {
                    playButton.configuration?.showsActivityIndicator = false
                    
                    switch error {
                    case .embeddedVideoPlayingNotAllowed:
                        UIApplication.shared.open(youtubeURL)
                    default:
                        break
                    }
                }
            })
        
        stateCancellable = hostingView.player.playbackStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] state in
                if state == .cued {
                    hostingView.player.play()
                }
                
                if state == .playing {
                    playButton.configuration?.showsActivityIndicator = false
                }
            })
        
        hostingView.player.cue(source: .url(youtubeURL.absoluteString))

    }
}

