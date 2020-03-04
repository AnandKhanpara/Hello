//
//  VideoView.swift
//  Hello
//
//  Created by ZerOnes on 10/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol VideoPlayerDelegate {
    func videoPlayerDidPlayToEndTime(_ player:AVPlayer, _ playerLayer:AVPlayerLayer, _ videoPlayer:VideoPlayer)
    func videoPlayerWillAddPlayer(_ player:AVPlayer, _ playerLayer:AVPlayerLayer, _ videoPlayer:VideoPlayer)
    func videoPlayerDidAddPlayer(_ player:AVPlayer, _ playerLayer:AVPlayerLayer, _ videoPlayer:VideoPlayer)
}


class VideoPlayer:UIView {
    
    var delegate:VideoPlayerDelegate?
    
    private var player = AVPlayer()
    private var playerLayer = AVPlayerLayer()
    let activity = UIActivityIndicatorView(style: .white)
    
    init(frame: CGRect = CGRect(), videoURL:URL? = nil) {
        super.init(frame: frame)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            self.delegate?.videoPlayerWillAddPlayer(self.player, self.playerLayer, self)
        }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            
            guard let videoURL = videoURL else { return }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            self.backgroundColor = .black
            
            self.player = AVPlayer(url: videoURL)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer.frame = self.bounds
            self.playerLayer.videoGravity = .resize
            self.playerLayer.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(self.playerLayer)
            self.addSubview(self.activity)
            self.activity.addCenter(self)
            
            self.player.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                self.playerLayer.frame = self.bounds
                self.delegate?.videoPlayerDidAddPlayer(self.player, self.playerLayer, self)
                self.activity.startAnimating()
                self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main, using: { time in
                    if self.player.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                        if let _ = self.player.currentItem?.isPlaybackLikelyToKeepUp {
                            self.activity.stopAnimating()
                        }else {
                            self.activity.startAnimating()
                        }
                    }
                })
            }
            
            
            
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.delegate?.videoPlayerDidPlayToEndTime(self.player, self.playerLayer, self)
    }
}

