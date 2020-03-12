//
//  MessageSenderTVCell.swift
//  Hello
//
//  Created by ZerOnes on 23/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit

class MessageTextSenderTVCell: UITableViewCell {

    
    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    var profile:User = User() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.profile.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
        }
    }
    
    var message:PersonalMessage = PersonalMessage() {
        didSet {
            self.lblMessageText.text = self.message.messageText
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class MessageDeleteSenderTVCell: UITableViewCell {

    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    var profile:User = User() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.profile.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
        }
    }
    
    var message:PersonalMessage = PersonalMessage() {
        didSet {
            self.lblMessageText.text = "You deleted this message"
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class MessageImageSenderTVCell: UITableViewCell {

    @IBOutlet weak var constraintViewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewImage: UIImageView!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    var profile:User = User() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.profile.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
        }
    }
    
    var message:PersonalMessage = PersonalMessage() {
        didSet {
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
            self.imgViewImage.sd_setImage(with: self.message.messageImageURL)
            self.imgViewImage.clipsToBounds = true
            self.imgViewImage.layer.cornerRadius = 10
            self.constraintViewImageHeight.constant = ((200 * self.message.imageHeight) / self.message.imageWidth)
            self.constraintViewImageWidth.constant = 200
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
                let longGesture = UILongPressGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_longGesture))
                longGesture.minimumPressDuration = 0.25
                longGesture.delegate = self
                self.viewSelectMessage.addGestureRecognizer(longGesture)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class MessageLocationSenderTVCell: UITableViewCell {
    
    @IBOutlet weak var constraintViewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewImage: UIImageView!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var mapViewLocation: MKMapView!
    
    var profile:User = User() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.profile.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
        }
    }
    
    var message:PersonalMessage = PersonalMessage() {
        didSet {
            self.lblAddress.text = self.message.messageAddress
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
            self.imgViewImage.image = UIImage(named: "message_location_image")
            self.imgViewImage.clipsToBounds = true
            self.imgViewImage.layer.cornerRadius = 10
            self.constraintViewImageHeight.constant = 200
            self.constraintViewImageWidth.constant = 200
            
            self.mapViewLocation.removeAnnotations( self.mapViewLocation.annotations )
            let coordinate = CLLocationCoordinate2D(latitude: self.message.messageLatitudeDouble, longitude: self.message.messageLongitudeDouble)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapViewLocation.addAnnotation(annotation)
            self.mapViewLocation.setRegion(region, animated: false)
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
                let tapGesture1 = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_tapGesture))
                tapGesture1.numberOfTapsRequired = 1
                tapGesture1.delegate = self
                self.viewSelectMessage.addGestureRecognizer(tapGesture1)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class MessageVideoSenderTVCell: UITableViewCell {

    @IBOutlet weak var constraintViewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewVideoThumbnail: UIImageView!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewPlayIcon: UIImageView!
    
    var profile:User = User() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.profile.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
        }
    }
    
    var message:PersonalMessage = PersonalMessage() {
        didSet {
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
            self.imgViewVideoThumbnail.sd_setImage(with: self.message.messageVideoThumbnailURL)
            self.imgViewVideoThumbnail.clipsToBounds = true
            self.imgViewVideoThumbnail.layer.cornerRadius = 10
            self.constraintViewImageHeight.constant = ((200 * self.message.imageHeight) / self.message.imageWidth)
            self.constraintViewImageWidth.constant = 200
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
                let tapGesture1 = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_tapGesture))
                tapGesture1.numberOfTapsRequired = 1
                tapGesture1.delegate = self
                self.viewSelectMessage.addGestureRecognizer(tapGesture1)
       
                let longGesture = UILongPressGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_longGesture))
                longGesture.minimumPressDuration = 0.25
                longGesture.delegate = self
                self.viewSelectMessage.addGestureRecognizer(longGesture)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}



//MARK:- Group

class GroupMessageTextSenderTVCell: UITableViewCell {
    
    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    var message:GroupMessage = GroupMessage() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.message.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
            self.lblMessageText.text = message.messageText
            self.lblMessageTime.text = message.createdAt.messageTimeDateFormatter()
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class GroupMessageDeleteSenderTVCell: UITableViewCell {

    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    var message:GroupMessage = GroupMessage() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.message.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
            self.lblMessageText.text = "You deleted this message"
            self.lblMessageTime.text = message.createdAt.messageTimeDateFormatter()
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class GroupMessageImageSenderTVCell: UITableViewCell {
    
    @IBOutlet weak var constraintViewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewImage: UIImageView!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!

    
    var message:GroupMessage = GroupMessage() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.message.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
            self.imgViewImage.sd_setImage(with: self.message.messageImageURL)
            self.imgViewImage.clipsToBounds = true
            self.imgViewImage.layer.cornerRadius = 10
            self.constraintViewImageHeight.constant = ((200 * self.message.imageHeight) / self.message.imageWidth)
            self.constraintViewImageWidth.constant = 200
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
                let longGesture = UILongPressGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_longGesture))
                longGesture.minimumPressDuration = 0.25
                longGesture.delegate = self
                self.viewSelectMessage.addGestureRecognizer(longGesture)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class GroupMessageLocationSenderTVCell: UITableViewCell {
    
    @IBOutlet weak var constraintViewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewImage: UIImageView!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var mapViewLocation: MKMapView!

    
    var message:GroupMessage = GroupMessage() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.message.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
            self.lblAddress.text = self.message.messageAddress
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
            self.imgViewImage.image = UIImage(named: "message_location_image")
            self.imgViewImage.clipsToBounds = true
            self.imgViewImage.layer.cornerRadius = 10
            self.constraintViewImageHeight.constant = 200
            self.constraintViewImageWidth.constant = 200
            
            self.mapViewLocation.removeAnnotations( self.mapViewLocation.annotations )
            let coordinate = CLLocationCoordinate2D(latitude: self.message.messageLatitudeDouble, longitude: self.message.messageLongitudeDouble)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapViewLocation.addAnnotation(annotation)
            self.mapViewLocation.setRegion(region, animated: false)
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
                let tapGesture1 = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_tapGesture))
                tapGesture1.numberOfTapsRequired = 1
                tapGesture1.delegate = self
                self.viewSelectMessage.addGestureRecognizer(tapGesture1)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class GroupMessageVideoSenderTVCell: UITableViewCell {

    @IBOutlet weak var constraintViewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewVideoThumbnail: UIImageView!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewSelectMessage: UIView!
    @IBOutlet weak var viewSelectProfile: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewPlayIcon: UIImageView!
    
    
    var message:GroupMessage = GroupMessage() {
        didSet {
            self.imgViewProfile.sd_setImage(with: self.message.profileURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 15
            self.lblMessageTime.text = self.message.createdAt.messageTimeDateFormatter()
            self.imgViewVideoThumbnail.sd_setImage(with: self.message.messageVideoThumbnailURL)
            self.imgViewVideoThumbnail.clipsToBounds = true
            self.imgViewVideoThumbnail.layer.cornerRadius = 10
            self.constraintViewImageHeight.constant = ((200 * self.message.imageHeight) / self.message.imageWidth)
            self.constraintViewImageWidth.constant = 200
        }
    }
    
    var indexPath:IndexPath = IndexPath() {
        didSet {
            let tag = self.indexPath.makeTag()
            self.tag = tag
            self.viewSelectMessage.tag = tag
            self.viewSelectProfile.tag = tag
        }
    }
    
    var parent:UIViewController = UIViewController() {
        didSet {
            if let parent = self.parent as? MessageVC {
                
                let tapGesture = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectProfile_tapGesture))
                tapGesture.numberOfTapsRequired = 1
                tapGesture.delegate = self
                self.viewSelectProfile.addGestureRecognizer(tapGesture)
                
                let tapGesture1 = UITapGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_tapGesture))
                tapGesture1.numberOfTapsRequired = 1
                tapGesture1.delegate = self
                self.viewSelectMessage.addGestureRecognizer(tapGesture1)
       
                let longGesture = UILongPressGestureRecognizer(target: parent, action: #selector(parent.viewSelectMessage_longGesture))
                longGesture.minimumPressDuration = 0.25
                longGesture.delegate = self
                self.viewSelectMessage.addGestureRecognizer(longGesture)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
