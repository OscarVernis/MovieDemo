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
    var youtubeId: String
    
    let buttonSize: CGFloat = 70
    
    private var hostingView: YouTubePlayerHostingView = {
        let configuration = YouTubePlayer.Configuration(autoPlay: false, playInline: false)
        return YouTubePlayerHostingView(player: YouTubePlayer(source: nil, configuration: configuration))
    }()
    
    private var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setupBorder()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
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
    
    init(previewURL: URL?, youtubeId: String) {
        self.previewImageURL = previewURL
        self.youtubeId = youtubeId
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
        
        stateCancellable = hostingView.player.playbackStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { state in
                if state == .cued {
                    self.hostingView.player.play()
                }
                if state == .playing {
                    self.playButton.configuration?.showsActivityIndicator = false
                }
            })
        
        hostingView.player.cue(source: .video(id: youtubeId))

    }
}
