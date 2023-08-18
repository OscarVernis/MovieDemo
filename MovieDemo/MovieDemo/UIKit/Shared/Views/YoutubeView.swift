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
    var previewImageURL = URL(string: "https://i.ytimg.com/vi/n9xhJrPXop4/hqdefault.jpg")!
    var youtubeId: String = "_YUzQa_1RCE"
    
    private var hostingView: YouTubePlayerHostingView = {
        let configuration = YouTubePlayer.Configuration(autoPlay: true, playInline: true)
        return YouTubePlayerHostingView(player: YouTubePlayer(source: nil, configuration: configuration))
    }()
    
    private var previewImageView = UIImageView()
    
    private var playButton: UIButton = {
        var configuration = UIButton.Configuration.borderedProminent()
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        return button
    }()
    
    private var stateCancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        addSubview(previewImageView)
        previewImageView.anchor(to: self)
        previewImageView.setRemoteImage(withURL: previewImageURL, animated: true)
        
        addSubview(hostingView)
        anchor(to: self)
        
        addSubview(playButton)
        playButton.anchor(width: 45, height: 45)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
    }
    
    @objc private func play() {
        stateCancellable = nil
        hostingView.player.cue(source: .video(id: youtubeId))
        
        if hostingView.player.state == .ready {
            print("play")
            hostingView.player.play()
        } else {
            print("cue")
            hostingView.player.cue(source: .video(id: youtubeId))
            
            stateCancellable = hostingView.player.statePublisher
                .sink(receiveValue: { state in
                    if state == .ready {
                        print("ready")
                        self.hostingView.player.play()
                        self.stateCancellable = nil
                    }
                })
        }
    }
}

import SwiftUI

struct SwiftUIYoutubeView: UIViewRepresentable {
    func makeUIView(context: Context) -> YoutubeView {
        return YoutubeView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

    }
    
    func updateUIView(_ view: YoutubeView, context: Context) {}
}

struct HelloWorldView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIYoutubeView()
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/))
            
    }
}
