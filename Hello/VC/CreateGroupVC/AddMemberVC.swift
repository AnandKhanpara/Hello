//
//  AddMemberVC.swift
//  Hello
//
//  Created by ZerOnes on 04/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class AddMemberTVCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
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
            self.btnAdd.tag = self.indexPath.makeTag()
            self.btnRemove.tag = self.indexPath.makeTag()
            
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? CreateGroupVC {
                
                self.btnAdd.addTarget(parent, action: #selector(parent.btnAdd_touchUpInside), for: .touchUpInside)
                self.btnRemove.addTarget(parent, action: #selector(parent.btnRemove_touchUpInside), for: .touchUpInside)
            
                if parent.arrAddFriends.filter({ $0.uId == self.user.uId }).count >= 1 {
                    self.btnAdd.isEnabled = false
                    self.btnRemove.isEnabled = true
                    self.btnAdd.alpha = 0.5
                    self.btnRemove.alpha = 1
                }else {
                    self.btnAdd.isEnabled = true
                    self.btnRemove.isEnabled = false
                    self.btnAdd.alpha = 1
                    self.btnRemove.alpha = 0.5
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

class NewMemberTVCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnAddNewMember: UIButton!
    
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
            let tagFixed = 10000000
            let tag = (tagFixed * (self.indexPath.section + 1)) + self.indexPath.row
            self.btnAddNewMember.tag = tag
            
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? CreateGroupVC {
                self.btnAddNewMember.addTarget(parent, action: #selector(parent.btnNewMember_touchUpInside), for: .touchUpInside)
            
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

class EditMemberTVCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnRemoveAddMember: UIButton!
    
    var userDetails:NSDictionary = NSDictionary() {
        didSet {
            if let details = self.userDetails["userDetails"] as? NSDictionary {
                let user = User(details)
                self.lblUserName.text = user.userName
                self.imgViewProfile.sd_setImage(with: user.profileURL)
                self.imgViewProfile.clipsToBounds = true
                self.imgViewProfile.layer.cornerRadius = 10
                
                
                if let admin = self.userDetails["admins"] as? NSDictionary {
                    if let _ = admin[user.uId] {
                        self.lblUserName.textColor = UIColor.blue
                        self.btnRemoveAddMember.setTitle("Admin", for: .normal)
                        self.btnRemoveAddMember.setTitleColor(UIColor.blue, for: .normal)
                        self.btnRemoveAddMember.layer.borderColor = UIColor.blue.cgColor
                        self.btnRemoveAddMember.isUserInteractionEnabled = false
                        if UserFetch.getSIData().uId == user.uId {
                            self.btnRemoveAddMember.alpha = 1
                        }else {
                            self.btnRemoveAddMember.alpha = 0.6
                        }
                    }else {
                        if admin[UserFetch.getSIData().uId] == nil {
                            self.btnRemoveAddMember.isUserInteractionEnabled = false
                            self.btnRemoveAddMember.setTitle("Remove", for: .normal)
                            self.btnRemoveAddMember.alpha = 0.6
                        }else {
                            self.btnRemoveAddMember.isUserInteractionEnabled = true
                            self.btnRemoveAddMember.setTitle("Remove", for: .normal)
                            self.btnRemoveAddMember.alpha = 1
                        }
                    }
                }
            }
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tagFixed = 10000000
            let tag = (tagFixed * (self.indexPath.section + 1)) + self.indexPath.row
            self.btnRemoveAddMember.tag = tag
            
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? CreateGroupVC {
                self.btnRemoveAddMember.addTarget(parent, action: #selector(parent.btnRemoveAddMember_touchUpInside), for: .touchUpInside)
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


