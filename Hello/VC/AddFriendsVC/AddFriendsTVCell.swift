//
//  AddFriendsTVCell.swift
//  Hello
//
//  Created by ZerOnes on 18/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import SDWebImage

class AddFriendsTVCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    
    var user:User = User() {
        didSet {
            self.lblUserName.text = self.user.userName
            self.imgViewProfile.sd_setImage(with: self.user.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 10
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.btnJoin.tag = tag
            self.btnCancel.tag = tag
            self.btnAccept.tag = tag
            self.btnRemove.tag = tag
            self.btnMessage.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? AddFriendsVC {
                
                self.btnJoin.addTarget(parent, action: #selector(parent.btnJoin_touchUpInside), for: .touchUpInside)
                self.btnAccept.addTarget(parent, action: #selector(parent.btnAccept_touchUpInside), for: .touchUpInside)
                self.btnCancel.addTarget(parent, action: #selector(parent.btnCancel_touchUpInside), for: .touchUpInside)
                self.btnRemove.addTarget(parent, action: #selector(parent.btnCancel_touchUpInside), for: .touchUpInside)
                self.btnMessage.addTarget(parent, action: #selector(parent.btnMessage_touchUpInside), for: .touchUpInside)
                
                self.btnJoin.isHidden = false
                self.btnAccept.isHidden = true
                self.btnCancel.isHidden = true
                self.btnRemove.isHidden = true
                self.btnMessage.isHidden = true
                
                if parent.arrReceiverRequest.contains(where: { $0.sender == self.user.uId && $0.acceptRequest == "0"}) {
                    self.btnJoin.isHidden = true
                    self.btnAccept.isHidden = false
                    self.btnCancel.isHidden = false
                    self.btnRemove.isHidden = true
                    self.btnMessage.isHidden = true
                }
                
                if parent.arrSenderRequest.contains(where: { $0.receiver == self.user.uId  && $0.acceptRequest == "0"  }) {
                    self.btnJoin.isHidden = true
                    self.btnAccept.isHidden = true
                    self.btnCancel.isHidden = false
                    self.btnRemove.isHidden = true
                    self.btnMessage.isHidden = true
                }
                
                let first = parent.arrSenderRequest.contains(where: { $0.receiver == self.user.uId && $0.acceptRequest == "1" })
                let second = parent.arrReceiverRequest.contains(where: {  $0.sender == self.user.uId  && $0.acceptRequest == "1" })
                
                if  first == true || second == true {
                    self.btnJoin.isHidden = true
                    self.btnAccept.isHidden = true
                    self.btnCancel.isHidden = true
                    self.btnRemove.isHidden = false
                    self.btnMessage.isHidden = false
                }
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
