//
//  LastMessageTVCell.swift
//  Hello
//
//  Created by ZerOnes on 01/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class LastMessageTVCell: UITableViewCell {
    
    
    @IBOutlet weak var constraintLBLLastMessageLeading: NSLayoutConstraint!

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnSelectViewUser: UIButton!
    
    @IBOutlet weak var imgViewLastMessage: UIImageView!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var lblLastMessageTime: UILabel!
    
    var lastMessage:LastMessage = LastMessage() {
        didSet {
            
            if self.lastMessage.chatTypes == .personal {
                self.lblUserName.text = self.lastMessage.userName
                self.imgViewProfile.sd_setImage(with: self.lastMessage.profileURL)
            }else if self.lastMessage.chatTypes == .group {
                self.lblUserName.text = self.lastMessage.groupName
                self.imgViewProfile.sd_setImage(with: self.lastMessage.groupImageLogoURL)
            }
            
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 10
            self.lblLastMessageTime.text = self.lastMessage.createdAt.messageTimeDateFormatter()
            if self.lastMessage.messageTypes == .text {
                self.lblLastMessage.text = self.lastMessage.messageText
                self.imgViewLastMessage.isHidden = true
                self.constraintLBLLastMessageLeading.constant = 10
            }else if self.lastMessage.messageTypes == .image {
                self.lblLastMessage.text = "Image"
                self.imgViewLastMessage.image = UIImage(named: "gallery")
                self.imgViewLastMessage.isHidden = false
                self.constraintLBLLastMessageLeading.constant = 40
            }else if self.lastMessage.messageTypes == .location {
                self.lblLastMessage.text = self.lastMessage.messageText
                self.imgViewLastMessage.image = UIImage(named: "location")
                self.imgViewLastMessage.isHidden = false
                self.constraintLBLLastMessageLeading.constant = 40
            }else if self.lastMessage.messageTypes == .video {
                self.lblLastMessage.text = "Video"
                self.imgViewLastMessage.image = UIImage(named: "video")
                self.imgViewLastMessage.isHidden = false
                self.constraintLBLLastMessageLeading.constant = 40
            }
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tagFixed = 10000000
            let tag = (tagFixed * (self.indexPath.section + 1)) + self.indexPath.row
            self.btnSelectViewUser.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? HomeVC {
                self.btnSelectViewUser.addTarget(parent, action: #selector(parent.btnSelectViewUser_touchUpInside), for: .touchUpInside)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}



