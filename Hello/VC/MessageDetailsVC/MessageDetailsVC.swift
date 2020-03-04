//
//  MessageDetailsVC.swift
//  Hello
//
//  Created by ZerOnes on 31/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class MessageDetailsVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var constraintViewDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewDetailsWidth: NSLayoutConstraint!
    @IBOutlet weak var viewDetailsBG: UIView!
    @IBOutlet weak var imgViewMessageImage: UIImageView!
    @IBOutlet weak var viewShadow: UIView!
    
    //MARK:- Variable
    
    var videoPlayerLayer:AVPlayerLayer = AVPlayerLayer()
    var videoPlayer:AVPlayer = AVPlayer()
    var videoPlayerView = VideoPlayer()
    var chatType:ChatType = .personal
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.applyShadow()
    }
    
    //MARK:- View SetUp
    
    func viewDidSetUp() {
        self.imgViewMessageImage.layer.cornerRadius = 10
        self.imgViewMessageImage.clipsToBounds = true
    }
    
    func viewWillSetUp() {
        
    }
    
    
    //MARK:- Action
    
    @IBAction func btnClose_touchUpInside(_ sender: UIButton) {
        self.hideMessageDetails(chatType: .personal)
    }
    
    //MARK:- Function
    
    func applyShadow() {
        self.viewShadow.layer.shadowPath = UIBezierPath(rect: self.viewShadow.bounds).cgPath
        self.viewShadow.layer.shadowRadius = 10
        self.viewShadow.layer.shadowColor = UIColor.black.cgColor
        self.viewShadow.layer.shadowOffset = .zero
        self.viewShadow.layer.shadowOpacity = 0.5
    }
    
//    func videoLayer(videoURL:URL, viewLayer:UIView) {
//        self.videoPlayer.pause()
//        self.videoPlayerLayer.removeFromSuperlayer()
//        let player = AVPlayer(url: videoURL)
//        let layer = AVPlayerLayer(player: player)
//        layer.frame = viewLayer.bounds
//        layer.videoGravity = .resize
//        viewLayer.layer.addSublayer(layer)
//        self.videoPlayerLayer = layer
//        self.videoPlayer = player
//        player.play()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
//            layer.frame = viewLayer.bounds
//        }
//    }
    
    func showMessageDetails(personalMessage:PersonalMessage? = nil, groupMessage:GroupMessage? = nil, chatType:ChatType) {
        self.view.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            UIView.animate(withDuration: 0.125) {
                self.view.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
        var messageType:MessageType = .text
        var messageImageWidth:CGFloat = 0.0
        var messageImageHeight:CGFloat = 0.0
        guard var messageImageURL = URL(string: "after_setup_message_image_url") else { return }
        guard var messageVideoThumbnailURL = URL(string: "after_setup_message_image_url") else { return }
        guard var messageVideoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
        
        if let message = personalMessage, chatType == .personal {
            self.chatType = .personal
            messageType = message.type
            messageImageWidth = message.imageWidth
            messageImageHeight = message.imageHeight
            if let url = message.messageImageURL {
                messageImageURL = url
            }
            if let url = message.messageVideoThumbnailURL {
                messageVideoThumbnailURL = url
            }
            if let url = message.messageVideoURL {
                messageVideoURL = url
            }
        }else if let message = groupMessage, chatType == .group {
            self.chatType = .group
            messageType = message.type
            messageImageWidth = message.imageWidth
            messageImageHeight = message.imageHeight
            if let url = message.messageImageURL {
                messageImageURL = url
            }
            if let url = message.messageVideoThumbnailURL {
                messageVideoThumbnailURL = url
            }
            if let url = message.messageVideoURL {
                messageVideoURL = url
            }
        }
        
        if messageImageWidth > messageImageHeight {
            var viewWidth = self.view.frame.width - 100
            viewWidth = viewWidth > messageImageWidth ? messageImageWidth : viewWidth
            self.constraintViewDetailsWidth.constant = viewWidth
            self.constraintViewDetailsHeight.constant = (messageImageHeight * viewWidth) / messageImageWidth
        }else {
            var viewHeight = self.view.frame.height - 100
            viewHeight = viewHeight > messageImageHeight ? messageImageHeight : viewHeight
            self.constraintViewDetailsWidth.constant = (messageImageWidth * viewHeight) / messageImageHeight
            self.constraintViewDetailsHeight.constant = viewHeight
        }
        
        if messageType == .image {
            self.imgViewMessageImage.sd_setImage(with: messageImageURL)
        }else if messageType == .video {
            self.imgViewMessageImage.sd_setImage(with: messageVideoThumbnailURL)
            self.videoLayer(videoURL: messageVideoURL, viewLayer: self.imgViewMessageImage)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0125) {
            self.applyShadow()
        }
    }
    
    func hideMessageDetails(personalMessage:PersonalMessage? = nil, groupMessage:GroupMessage? = nil, chatType:ChatType) {
        DispatchQueue.main.async {
            self.view.isHidden = true
            self.imgViewMessageImage.image = nil
            self.removeVideoPlayer()
        }
    }
    
    //MARK:- Web Service
    
}

//MARK:- Extension

extension MessageDetailsVC : VideoPlayerDelegate {
    
    func videoLayer(videoURL:URL, viewLayer:UIView) {
        let video = VideoPlayer(videoURL: videoURL)
        video.delegate = self
        viewLayer.addSubview(video)
        video.addBounds(viewLayer)
    }
    
    func removeVideoPlayer() {
        self.videoPlayer.pause()
        self.videoPlayerLayer.removeFromSuperlayer()
        self.videoPlayerView.removeFromSuperview()
    }
    
    func videoPlayerDidPlayToEndTime(_ player: AVPlayer, _ playerLayer: AVPlayerLayer, _ videoPlayer: VideoPlayer) {
        player.seek(to: .zero)
        player.play()
    }
    
    func videoPlayerDidAddPlayer(_ player: AVPlayer, _ playerLayer: AVPlayerLayer, _ videoPlayer: VideoPlayer) {
        self.videoPlayerView = videoPlayer
        self.videoPlayerLayer = playerLayer
        self.videoPlayer = player
        print("videoPlayerDidAddPlayer")
    }
    
    func videoPlayerWillAddPlayer(_ player: AVPlayer, _ playerLayer: AVPlayerLayer, _ videoPlayer: VideoPlayer) {
        self.removeVideoPlayer()
        print("videoPlayerWillAddPlayer")
    }
}
