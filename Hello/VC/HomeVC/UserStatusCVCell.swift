//
//  UserStatusCVCell.swift
//  Hello
//
//  Created by ZerOnes on 07/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class UserStatusCVCell: UICollectionViewCell {
    
    
    @IBOutlet weak var btnSelectStatus: UIButton!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgViewStatusImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgViewUserProfile: UIImageView!
    @IBOutlet weak var viewProfileShadow: UIView!
    
    var userStatus:UserStatus = UserStatus() {
        didSet {
            self.imgViewStatusImage.layer.cornerRadius = 10
            self.imgViewStatusImage.clipsToBounds = true
            
            self.imgViewUserProfile.layer.cornerRadius = 20
            self.imgViewUserProfile.clipsToBounds = true
            
            self.shadowView(view: self.viewProfileShadow, cornerRadius: 20, shadowColor: .red)
            self.shadowView(view: self.viewShadow)
            
            self.lblUserName.text = self.userStatus.userName
            self.imgViewUserProfile.sd_setImage(with: self.userStatus.userProfileURL)
            self.imgViewStatusImage.sd_setImage(with: self.userStatus.firstStatus.statusImageURL)
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            self.btnSelectStatus.tag = self.indexPath.row
            self.btnSelectStatus.addTarget(self, action: #selector(btnSelectStatus_touchUpInside), for: .touchUpInside)
        }
    }
    
    func shadowView(view:UIView, cornerRadius:CGFloat = 5, shadowColor:UIColor = .black) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            view.layer.shadowColor = shadowColor.cgColor
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
            view.layer.shadowRadius = cornerRadius
            view.layer.shadowOffset = .zero
            view.layer.shadowOpacity = 0.4
            view.layer.masksToBounds = false
        }
    }
    
    @objc func btnSelectStatus_touchUpInside(sender:UIButton) {
        parentHomeVC.showStatusView(index: sender.tag, userStatus: self.userStatus)
    }
    
}
