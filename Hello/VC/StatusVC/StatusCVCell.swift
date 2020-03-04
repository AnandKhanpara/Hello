//
//  StatusCVCell.swift
//  Hello
//
//  Created by ZerOnes on 08/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class StatusCVCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var constraintDetailsViewTop: NSLayoutConstraint!
    @IBOutlet weak var imgViewStatusImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCreateAt: UILabel!
    @IBOutlet weak var imgViewUserProfile: UIImageView!
    
  
    var status:StatusDetails = StatusDetails() {
        didSet {
            self.constraintDetailsViewTop.constant = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
            self.imgViewStatusImage.backgroundColor = .black
            self.imgViewStatusImage.sd_setImage(with: status.statusImageURL)
            self.imgViewUserProfile.layer.cornerRadius = 25
            self.imgViewUserProfile.clipsToBounds = true
            self.lblUserName.text = status.userName
            self.lblCreateAt.text = status.createdAt.stringToDate().changeTimeZone(inputTZ: TimeZone(abbreviation: "UTC"), outputTZ: .current).stringToDate().changeDateFormate("E hh:mm a", timeZone: .current)
        }
    }
    
    var userStatus:UserStatus = UserStatus() {
        didSet {
            self.imgViewUserProfile.sd_setImage(with: self.userStatus.userProfileURL)
        }
    }
    
    @objc func viewClose_tapGesture(gesture:UITapGestureRecognizer) {
        print("gesture click")
    }
}

















































































































































