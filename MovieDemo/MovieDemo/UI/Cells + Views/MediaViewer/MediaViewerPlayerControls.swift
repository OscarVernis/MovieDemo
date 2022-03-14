//
//  MediaViewerPlayerControls.swift
//  MediaViewer
//
//  Created by Oscar Vernis on 01/10/20.
//

import UIKit
import AVKit

class MediaViewerPlayerControls: UIView {
    unowned var player: AVPlayer? = nil {
        didSet {
            setup()
        }
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeProgressLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var transportSlider: UISlider!
    
    var playerOberservationToken: NSKeyValueObservation? = nil
    
    //MARK:- UIView
    override func awakeFromNib() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    deinit {
        playerOberservationToken?.invalidate()
    }
    
    //MARK:- Setup
    fileprivate func setup() {
        transportSlider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        transportSlider.setThumbImage(UIImage(named: "thumb"), for: .highlighted)
        
        playerOberservationToken = player?.observe(\.timeControlStatus, changeHandler: { player, change in
            switch player.timeControlStatus {
            case .paused:
                self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            case .playing:
                self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            default:
                break
            }
        })
        
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateControls(time: time)
        }
        
    }
    
    fileprivate func updateControls(time: CMTime) {        
        guard let duration = player?.currentItem?.duration else { return }

        //Set labels
        let remaining = duration - time
        self.timeProgressLabel.text = time.formattedString
        self.remainingTimeLabel.text = "-" + remaining.formattedString
        
        guard !transportSlider.isTracking else { return }

        //Set Slider
        let progress = time.seconds / duration.seconds
        transportSlider.value = Float(progress)
        
    }
    
    //MARK:- Actions
    @IBAction func playButtonTapped() {
        switch player?.timeControlStatus {
        case .playing:
            player?.pause()
        case .paused:
            player?.play()
        default:
            break
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        guard let currentItem = player?.currentItem else { return }
        
        let seconds = currentItem.duration.seconds * Double(transportSlider.value)
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        updateControls(time: time)
        player?.seek(to: time)
    }
    
}

extension CMTime {
    var formattedString: String {

        let totalSeconds = seconds
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
}
