//
//  MediaViewerPlayerView.swift
//  MediaViewer
//
//  Created by Oscar Vernis on 01/10/20.
//

import AVKit

class MediaViewerPlayerView: UIView {
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    let videoURL: URL
    
    init(url: URL) {
        self.videoURL = url
        super.init(frame: .zero)
        
        createViews()
        layer.masksToBounds = true
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createViews() {
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
    }
    
    override func layoutSubviews() {
        playerLayer.frame = bounds
    }
    
    func play() {
        player.play()
    }
    
    
}
