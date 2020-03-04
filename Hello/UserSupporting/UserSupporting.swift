//
//  UserSupporting.swift
//  Hello
//
//  Created by ZerOnes on 18/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import Foundation
import UIKit

class UserFetch : NSObject {
    
    static func setSIStatus(_ status:Bool) {
        UserStandard.set(status, forKey: K.US_USER_SIGNIN_STATUS)
        UserStandard.synchronize()
    }
    
    static func getSIStatus() -> Bool {
        return UserStandard.value(forKey: K.US_USER_SIGNIN_STATUS) as? Bool ?? false
    }
    
    static func setSIData(_ data:NSDictionary) {
        UserStandard.set(data, forKey: K.US_USER_SIGNIN_DATA)
        UserStandard.synchronize()
    }
    
    static func getSIData() -> User {
        let data = UserStandard.value(forKey: K.US_USER_SIGNIN_DATA) as? NSDictionary ?? NSDictionary()
        return User(data)
    }
}


class UserSet: NSObject {
    
    static func makeUIDCombination(firstId:String, secondId:String) -> String {
        if firstId > secondId {
            return firstId + "_" + secondId
        }else {
            return secondId + "_" + firstId
        }
    }
}

struct User {
    
    var email:String
    var password:String
    var uId:String
    var userName:String
    var createdAt:String
    var profile:String
    
    var profileURL:URL?
    
    init(email:String, password:String, uId:String, userName:String, createdAt:String, profile:String) {
        self.email = email
        self.password = password
        self.uId = uId
        self.userName = userName
        self.createdAt = createdAt
        self.profile = profile
        
        self.profileURL = URL(string: profile)
    }
    
    init(_ dictionary:NSDictionary = NSDictionary()) {
        self.email = dictionary[K.EMAIL] as? String ?? ""
        self.password = dictionary[K.PASSWORD] as? String ?? ""
        self.uId = dictionary[K.UID] as? String ?? ""
        self.userName = dictionary[K.USERNAME] as? String ?? ""
        self.createdAt = dictionary[K.CREATEDAT] as? String ?? ""
        self.profile = dictionary[K.PROFILE] as? String ?? ""
        
        self.profileURL =  URL(string: dictionary[K.PROFILE] as? String ?? "")
    }
}


struct JoinRequest {
    
    var acceptRequest:String
    var createdAt:String
    var joinFriendsRequestId:String
    var receiver:String
    var sender:String
    
    init(acceptRequest:String, createdAt:String, joinFriendsRequestId:String, receiver:String, sender:String) {
        self.acceptRequest = acceptRequest
        self.createdAt = createdAt
        self.joinFriendsRequestId = joinFriendsRequestId
        self.receiver = receiver
        self.sender = sender
    }
    
    init(_ dictionary:NSDictionary = NSDictionary()) {
        self.acceptRequest = dictionary[K.ACCEPT_REQUEST] as? String ?? ""
        self.createdAt = dictionary[K.CREATEDAT] as? String ?? ""
        self.joinFriendsRequestId = dictionary[K.JOIN_FRIENDS_REQUEST_ID] as? String ?? ""
        self.receiver = dictionary[K.RECEIVER] as? String ?? ""
        self.sender = dictionary[K.SENDER] as? String ?? ""
    }
}

struct GroupMessageDay {
    
    let date:String
    let messages:[GroupMessage]
    
    init(date:Any, messages:Any) {
        self.date = date as? String ?? ""
        let messages = messages as? NSDictionary ?? NSDictionary()
        let keyMessagesValue = messages.allValues as? [NSDictionary] ?? [NSDictionary]()
        self.messages = keyMessagesValue.map({ GroupMessage($0) }).filter({ $0.isMessageUserPermanentDeleted == false }).sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    init(date:String, messages:[GroupMessage]) {
        self.date = date
        self.messages = messages
    }
}


//createdAt = "2020-02-06 11:33:02 GMT";
//profile = "https://firebasestorage.googleapis.com/v0/b/hello-b8d65.appspot.com/o/Hello_Images%2FAB0429B5-4057-4943-B28A-EB202C08B9A9_202002050442456760?alt=media&token=f5d2d6f7-e4c3-4288-b8ff-d9ff82b12d66";
//statusId = "3D787BD6-0B55-47C8-AC13-291DE6EA0579";
//statusImage = "https://firebasestorage.googleapis.com/v0/b/hello-b8d65.appspot.com/o/Hello_StatusImage%2FAB0429B5-4057-4943-B28A-EB202C08B9A9_3D787BD6-0B55-47C8-AC13-291DE6EA0579_202002061133025510?alt=media&token=ee64bed3-d676-4c58-98df-0a7c5f3fe8a7";
//statusImageHeight = "267.0";
//statusImageWidth = "400.0";
//statusType = image;
//uId = "AB0429B5-4057-4943-B28A-EB202C08B9A9";
//userName = Anand;

struct UserStatus {
    
    var userId:String
    var userName:String
    var userProfile:String
    var firstStatus:StatusDetails
    var arrStatus:[StatusDetails]
    
    var userProfileURL:URL?
    
    init(userId:String = "", status:NSDictionary = NSDictionary()) {
        
        let arrS = (status.allValues as? [NSDictionary] ?? [NSDictionary]())
        self.userId = userId
        self.arrStatus = arrS.map({ StatusDetails($0)}).sorted(by: {$0.createdAt > $1.createdAt})
        self.firstStatus = self.arrStatus.first ?? StatusDetails()
        self.userName = self.firstStatus.userName
        self.userProfile = self.firstStatus.profile
        
        self.userProfileURL = URL(string: self.userProfile)
    }
    
    init(userId:String, userName:String ,userProfile:String, firstStatus:StatusDetails, arrStatus:[StatusDetails]) {
        
        self.userId = userId
        self.arrStatus = arrStatus
        self.firstStatus = firstStatus
        self.userName = userName
        self.userProfile = userProfile
        
        self.userProfileURL = URL(string: userProfile)
    }
    
}

struct StatusDetails {
    
    var createdAt:String
    var uId:String
    var userName:String
    var profile:String
    var statusId:String
    var statusImage:String
    var statusImageHeight:String
    var statusImageWidth:String
    var statusType:String
    
    var statusTypes:StatusType
    var imageHeight:CGFloat
    var imageWidth:CGFloat
    var statusImageURL:URL?

    init(_ dictionary:NSDictionary = NSDictionary()) {
      
        self.createdAt = dictionary[K.CREATEDAT] as? String ?? ""
        self.uId = dictionary[K.UID] as? String ?? ""
        self.userName = dictionary[K.USERNAME] as? String ?? ""
        self.profile = dictionary[K.PROFILE] as? String ?? ""
        self.statusId = dictionary[K.STATUS_ID] as? String ?? ""
        self.statusImage = dictionary[K.STATUS_IMAGE] as? String ?? ""
        self.statusImageHeight = dictionary[K.STATUS_IMAGE_HEIGHT] as? String ?? ""
        self.statusImageWidth = dictionary[K.STATUS_IMAGE_WIDTH] as? String ?? ""
        self.statusType = dictionary[K.STATUS_TYPE] as? String ?? ""
  
        self.statusImageURL = URL(string: self.statusImage)
        
        if self.statusType == StatusType.image.type {
            self.statusTypes = .image
        }else if self.statusType == StatusType.video.type {
            self.statusTypes = .video
        }else {
            self.statusTypes = .image
        }
        
        self.imageWidth = CGFloat(Double(self.statusImageWidth) ?? 0)
        self.imageHeight = CGFloat(Double(self.statusImageHeight) ?? 0)
        
    }
    
    init(createdAt:String, uId:String, profile:String, userName:String, statusId:String, statusImage:String, statusImageHeight:String, statusImageWidth:String, statusType:String) {
        
        self.createdAt = createdAt
        self.uId = uId
        self.userName = userName
        self.profile = profile
        self.statusId = statusId
        self.statusImage = statusImage
        self.statusImageHeight = statusImageHeight
        self.statusImageWidth = statusImageWidth
        self.statusType = statusType
        
        self.statusImageURL = URL(string: statusImage)
        
        if statusType == StatusType.image.type {
            self.statusTypes = .image
        }else if statusType == StatusType.video.type {
            self.statusTypes = .video
        }else {
            self.statusTypes = .image
        }
        
        self.imageWidth = CGFloat(Double(statusImageWidth) ?? 0)
        self.imageHeight = CGFloat(Double(statusImageHeight) ?? 0)
    }
}

struct GroupMessage {
    
    var uId:String
    var groupId:String
    var createdAt:String
    var profile:String
    var senderName:String
    var sender:String
    var messageType:String
    var messageText:String
    var messageImage:String
    var messageVideo:String
    var messageVideoThumbnail:String
    var messageImageHeight:String
    var messageImageWidth:String
    var messageAddress:String
    var messageLatitude:String
    var messageLongitude:String
    var groupMessageDeletedUser:NSDictionary
    
    var type:MessageType
    var isMessageUserDelete:Bool
    var isMessageUserPermanentDeleted:Bool
    var profileURL:URL?
    var messageImageURL:URL?
    var messageVideoURL:URL?
    var messageVideoThumbnailURL:URL?
    var imageHeight:CGFloat
    var imageWidth:CGFloat
    var messageLatitudeDouble:Double
    var messageLongitudeDouble:Double
    
    
    init(_ dictionary:NSDictionary = NSDictionary()) {
        
        self.uId = dictionary[K.UID] as? String ?? ""
        self.createdAt = dictionary[K.CREATEDAT] as? String ?? ""
        self.groupId = dictionary[K.GROUP_ID] as? String ?? ""
        self.senderName = dictionary[K.SENDER_NAME] as? String ?? ""
        self.profile = dictionary[K.PROFILE] as? String ?? ""
        self.sender = dictionary[K.SENDER] as? String ?? ""
        self.messageType = dictionary[K.MESSAGE_TYPE] as? String ?? ""
        self.messageText = dictionary[K.MESSAGE_TEXT] as? String ?? ""
        self.messageImage = dictionary[K.MESSAGE_IMAGE] as? String ?? ""
        self.messageVideo = dictionary[K.MESSAGE_VIDEO] as? String ?? ""
        self.messageVideoThumbnail = dictionary[K.MESSAGE_VIDEO_THUMBNAIL] as? String ?? ""
        self.messageImageHeight = dictionary[K.MESSAGE_IMAGE_HEIGHT] as? String ?? ""
        self.messageImageWidth = dictionary[K.MESSAGE_IMAGE_WIDTH] as? String ?? ""
        self.messageAddress = dictionary[K.MESSAGE_ADDRESS] as? String ?? ""
        self.messageLatitude = dictionary[K.MESSAGE_LATITUDE] as? String ?? ""
        self.messageLongitude = dictionary[K.MESSAGE_LONGITUDE] as? String ?? ""
        self.groupMessageDeletedUser = dictionary[K.GROUP_MESSAGE_DELETED_USER] as? NSDictionary ?? NSDictionary()
        
        let user = self.groupMessageDeletedUser[UserFetch.getSIData().uId] as? NSDictionary ?? NSDictionary()
        let userDeleteStatus = user[UserFetch.getSIData().uId] as? String ?? "0"
        
        if self.messageType == MessageType.video.type {
            self.type = .video
        }else if self.messageType == MessageType.image.type {
            self.type = .image
        }else if self.messageType == MessageType.location.type {
            self.type = .location
        }else {
            self.type = .text
        }
        
        self.profileURL = URL(string: self.profile)
        self.messageImageURL = URL(string: self.messageImage)
        self.messageVideoURL = URL(string: self.messageVideo)
        self.messageVideoThumbnailURL = URL(string: self.messageVideoThumbnail)
        
        self.isMessageUserDelete = (userDeleteStatus == "1" || userDeleteStatus == "2") ? true : false
        self.isMessageUserPermanentDeleted = userDeleteStatus == "2" ? true : false
        
        self.imageHeight = CGFloat(Double(self.messageImageHeight) ?? 0)
        self.imageWidth = CGFloat(Double(self.messageImageWidth) ?? 0)
        
        self.messageLatitudeDouble = Double(self.messageLatitude) ?? 0
        self.messageLongitudeDouble = Double(self.messageLongitude) ?? 0
    }
    
    init(createdAt:String, uId:String, groupId:String, profile:String, senderName:String, sender:String, messageType:String, messageText:String, messageImage:String, messageVideo:String, messageVideoThumbnail:String, messageImageHeight:String, messageImageWidth:String, messageAddress:String, messageLatitude:String, messageLongitude:String, groupMessageDeletedUser:NSDictionary) {
        
        self.uId = uId
        self.createdAt = createdAt
        self.groupId = groupId
        self.sender = sender
        self.profile = profile
        self.senderName = senderName
        self.messageType = messageType
        self.messageText = messageText
        self.messageImage = messageImage
        self.messageVideo = messageVideo
        self.messageVideoThumbnail = messageVideoThumbnail
        self.messageImageHeight = messageImageHeight
        self.messageImageWidth = messageImageWidth
        self.messageAddress = messageAddress
        self.messageLatitude = messageLatitude
        self.messageLongitude = messageLongitude
        self.groupMessageDeletedUser = groupMessageDeletedUser
        
        let user = self.groupMessageDeletedUser[UserFetch.getSIData().uId] as? NSDictionary ?? NSDictionary()
        let userDeleteStatus = user[UserFetch.getSIData().uId] as? String ?? "0"
        
        if messageType == MessageType.video.type {
            self.type = .video
        }else if messageType == MessageType.image.type {
            self.type = .image
        }else if messageType == MessageType.location.type {
            self.type = .location
        }else {
            self.type = .text
        }
        
        self.profileURL = URL(string: profile)
        self.messageImageURL = URL(string: messageImage)
        self.messageVideoURL = URL(string: messageVideo)
        self.messageVideoThumbnailURL = URL(string: messageVideoThumbnail)
        
        self.isMessageUserDelete = (userDeleteStatus == "1" || userDeleteStatus == "2") ? true : false
        self.isMessageUserPermanentDeleted = userDeleteStatus == "2" ? true : false
        
        self.imageHeight = CGFloat(Double(messageImageHeight) ?? 0)
        self.imageWidth = CGFloat(Double(messageImageWidth) ?? 0)
        
        self.messageLatitudeDouble = Double(messageLatitude) ?? 0
        self.messageLongitudeDouble = Double(messageLongitude) ?? 0
    }
}

struct PersonalMessageDay {
    
    let date:String
    let messages:[PersonalMessage]
    
    init(date:Any, messages:Any) {
        self.date = date as? String ?? ""
        let messages = messages as? NSDictionary ?? NSDictionary()
        let keyMessagesValue = messages.allValues as? [NSDictionary] ?? [NSDictionary]()
        self.messages = keyMessagesValue.map({ PersonalMessage($0) }).filter({ (($0.sender == UserFetch.getSIData().uId && $0.messageIsSenderDelete != "2") || ($0.receiver == UserFetch.getSIData().uId && $0.messageIsReceiverDelete != "2")) }).sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    init(date:String, messages:[PersonalMessage]) {
        self.date = date
        self.messages = messages
    }
}

struct PersonalMessage {
    
    var uId:String
    var createdAt:String
    var receiver:String
    var sender:String
    var messageType:String
    var messageText:String
    var messageImage:String
    var messageVideo:String
    var messageVideoThumbnail:String
    var messageImageHeight:String
    var messageImageWidth:String
    var messageIsReceiverDelete:String
    var messageIsSenderDelete:String
    var messageAddress:String
    var messageLatitude:String
    var messageLongitude:String
    
    var type:MessageType
    var isMessageSenderDelete:Bool
    var isMessageReceiverDelete:Bool
    var isMessageSenderPermanentDeleted:Bool
    var isMessageReceiverPermanentDeleted:Bool
    var messageImageURL:URL?
    var messageVideoURL:URL?
    var messageVideoThumbnailURL:URL?
    var imageHeight:CGFloat
    var imageWidth:CGFloat
    var messageLatitudeDouble:Double
    var messageLongitudeDouble:Double
    
    
    init(_ dictionary:NSDictionary = NSDictionary()) {
        
        self.uId = dictionary[K.UID] as? String ?? ""
        self.createdAt = dictionary[K.CREATEDAT] as? String ?? ""
        self.receiver = dictionary[K.RECEIVER] as? String ?? ""
        self.sender = dictionary[K.SENDER] as? String ?? ""
        self.messageType = dictionary[K.MESSAGE_TYPE] as? String ?? ""
        self.messageText = dictionary[K.MESSAGE_TEXT] as? String ?? ""
        self.messageImage = dictionary[K.MESSAGE_IMAGE] as? String ?? ""
        self.messageVideo = dictionary[K.MESSAGE_VIDEO] as? String ?? ""
        self.messageVideoThumbnail = dictionary[K.MESSAGE_VIDEO_THUMBNAIL] as? String ?? ""
        self.messageImageHeight = dictionary[K.MESSAGE_IMAGE_HEIGHT] as? String ?? ""
        self.messageImageWidth = dictionary[K.MESSAGE_IMAGE_WIDTH] as? String ?? ""
        self.messageIsSenderDelete = dictionary[K.MESSAGE_IS_SENDER_DELETE] as? String ?? ""
        self.messageIsReceiverDelete = dictionary[K.MESSAGE_IS_RECEIVER_DELETE] as? String ?? ""
        self.messageAddress = dictionary[K.MESSAGE_ADDRESS] as? String ?? ""
        self.messageLatitude = dictionary[K.MESSAGE_LATITUDE] as? String ?? ""
        self.messageLongitude = dictionary[K.MESSAGE_LONGITUDE] as? String ?? ""
        
        if self.messageType == MessageType.video.type {
            self.type = .video
        }else if self.messageType == MessageType.image.type {
            self.type = .image
        }else if self.messageType == MessageType.location.type {
            self.type = .location
        }else {
            self.type = .text
        }
        
        self.messageImageURL = URL(string: self.messageImage)
        self.messageVideoURL = URL(string: self.messageVideo)
        self.messageVideoThumbnailURL = URL(string: self.messageVideoThumbnail)
        
        self.isMessageSenderDelete = self.messageIsSenderDelete == "1"
        self.isMessageReceiverDelete = self.messageIsReceiverDelete == "1"
        
        self.isMessageSenderPermanentDeleted = self.messageIsSenderDelete == "2"
        self.isMessageReceiverPermanentDeleted = self.messageIsReceiverDelete == "2"
        
        self.imageHeight = CGFloat(Double(self.messageImageHeight) ?? 0)
        self.imageWidth = CGFloat(Double(self.messageImageWidth) ?? 0)
        
        self.messageLatitudeDouble = Double(self.messageLatitude) ?? 0
        self.messageLongitudeDouble = Double(self.messageLongitude) ?? 0
    }
    
    init(createdAt:String, uId:String, sender:String, receiver:String, messageType:String, messageText:String, messageImage:String, messageVideo:String, messageVideoThumbnail:String, messageImageHeight:String, messageImageWidth:String, messageIsSenderDelete:String, messageIsReceiverDelete:String, messageAddress:String, messageLatitude:String, messageLongitude:String) {
        
        self.uId = uId
        self.createdAt = createdAt
        self.receiver = receiver
        self.sender = sender
        self.messageType = messageType
        self.messageText = messageText
        self.messageImage = messageImage
        self.messageVideo = messageVideo
        self.messageVideoThumbnail = messageVideoThumbnail
        self.messageImageHeight = messageImageHeight
        self.messageImageWidth = messageImageWidth
        self.messageIsSenderDelete = messageIsSenderDelete
        self.messageIsReceiverDelete = messageIsReceiverDelete
        self.messageAddress = messageAddress
        self.messageLatitude = messageLatitude
        self.messageLongitude = messageLongitude
        
        if messageType == MessageType.video.type {
            self.type = .video
        }else if messageType == MessageType.image.type {
            self.type = .image
        }else if messageType == MessageType.location.type {
            self.type = .location
        }else {
            self.type = .text
        }
        
        self.messageImageURL = URL(string: messageImage)
        self.messageVideoURL = URL(string: messageVideo)
        self.messageVideoThumbnailURL = URL(string: messageVideoThumbnail)
        
        self.isMessageSenderDelete = messageIsSenderDelete == "1"
        self.isMessageReceiverDelete = messageIsReceiverDelete == "1"
        
        self.isMessageSenderPermanentDeleted = messageIsSenderDelete == "2"
        self.isMessageReceiverPermanentDeleted = messageIsReceiverDelete == "2"
        
        self.imageHeight = CGFloat(Double(messageImageHeight) ?? 0)
        self.imageWidth = CGFloat(Double(messageImageWidth) ?? 0)
        
        self.messageLatitudeDouble = Double(messageLatitude) ?? 0
        self.messageLongitudeDouble = Double(messageLongitude) ?? 0
    }
}

struct LastMessage {
    
    var uId:String
    var createdAt:String
    var receiver:String
    var sender:String
    var messageType:String
    var messageText:String
    var chatType:String
    var profile:String
    var userName:String
    var groupId:String
    var groupName:String
    var groupImageLogo:String
    
    var profileURL:URL?
    var groupImageLogoURL:URL?
    var messageTypes:MessageType
    var chatTypes:ChatType
    
    

    init(_ dictionary:NSDictionary = NSDictionary()) {
        
        self.uId = dictionary[K.UID] as? String ?? ""
        self.createdAt = dictionary[K.CREATEDAT] as? String ?? ""
        self.receiver = dictionary[K.RECEIVER] as? String ?? ""
        self.sender = dictionary[K.SENDER] as? String ?? ""
        self.messageType = dictionary[K.MESSAGE_TYPE] as? String ?? ""
        self.messageText = dictionary[K.MESSAGE_TEXT] as? String ?? ""
        self.chatType = dictionary[K.CHAT_TYPE] as? String ?? ""
        self.profile = dictionary[K.PROFILE] as? String ?? ""
        self.userName = dictionary[K.USERNAME] as? String ?? ""
        self.groupId = dictionary[K.GROUP_ID] as? String ?? ""
        self.groupName = dictionary[K.GROUP_NAME] as? String ?? ""
        self.groupImageLogo = dictionary[K.GROUP_IMAGE_LOGO] as? String ?? ""
        
        self.profileURL = URL(string: self.profile)
        self.groupImageLogoURL = URL(string: self.groupImageLogo)
        
        if self.messageType == MessageType.video.type {
            self.messageTypes = .video
        }else if self.messageType == MessageType.image.type {
            self.messageTypes = .image
        }else {
            self.messageTypes = .text
        }
        
        if self.chatType == ChatType.personal.type {
            self.chatTypes = .personal
        }else if self.chatType == ChatType.group.type {
            self.chatTypes = .group
        }else {
            self.chatTypes = .personal
        }
    }
    
    init(createdAt:String, uId:String, sender:String, receiver:String, messageType:String, messageText:String, chatType:String, profile:String, userName:String, groupId:String, groupName:String, groupImageLogo:String) {
        
        self.uId = uId
        self.createdAt = createdAt
        self.receiver = receiver
        self.sender = sender
        self.messageType = messageType
        self.messageText = messageText
        self.chatType = chatType
        self.profile = profile
        self.userName = userName
        self.groupId = groupId
        self.groupName = groupName
        self.groupImageLogo = groupImageLogo
        
        self.profileURL = URL(string: profile)
        self.groupImageLogoURL = URL(string: groupImageLogo)
        
        if messageType == MessageType.video.type {
            self.messageTypes = .video
        }else if messageType == MessageType.image.type {
            self.messageTypes = .image
        }else {
            self.messageTypes = .text
        }
        
        if chatType == ChatType.personal.type {
            self.chatTypes = .personal
        }else if chatType == ChatType.group.type {
            self.chatTypes = .group
        }else {
            self.chatTypes = .personal
        }
    }
}


struct Group {
    
    var member:NSDictionary
    var adminMembers:NSDictionary
    var groupDetails:GroupDetails
    var lastMessage:LastMessage
    
    init(_ dictionary:NSDictionary = NSDictionary()) {
        var stringAnyDic = dictionary as? [String:Any] ?? [String:Any]()
        let lastMessage = stringAnyDic[K.GROUP_LAST_MESSAGE] as? NSDictionary ?? NSDictionary()
        let groupDetails = stringAnyDic[K.GROUP_DETAILS] as? NSDictionary ?? NSDictionary()
        let adminMembers = stringAnyDic[K.GROUP_ADMIN_MEMBERS] as? NSDictionary ?? NSDictionary()
        stringAnyDic.removeValue(forKey: K.GROUP_DETAILS)
        stringAnyDic.removeValue(forKey: K.GROUP_LAST_MESSAGE)
        stringAnyDic.removeValue(forKey: K.GROUP_ADMIN_MEMBERS)
        self.groupDetails = GroupDetails(groupDetails)
        self.lastMessage = LastMessage(lastMessage)
        self.adminMembers = adminMembers
        self.member = stringAnyDic as NSDictionary
    }
    
    init(groupDetails:GroupDetails, lastMessage:LastMessage, member:NSDictionary, adminMembers:NSDictionary) {
        
        self.groupDetails = groupDetails
        self.lastMessage = lastMessage
        self.member = member
        self.adminMembers = adminMembers
    }
    
}

struct GroupDetails {
    
    var groupId:String
    var createdAt:String
    var chatType:String
    var groupImageLogo:String
    var groupName:String
    
    var groupImageLogoURL:URL?
    var chatTypes:ChatType
    
    init(_ dictionary:NSDictionary = NSDictionary()) {
        
        self.groupId = dictionary[K.GROUP_ID] as? String ?? ""
        self.createdAt = dictionary[K.CREATEDAT] as? String ?? ""
        self.groupImageLogo = dictionary[K.GROUP_IMAGE_LOGO] as? String ?? ""
        self.groupName = dictionary[K.GROUP_NAME] as? String ?? ""
        self.chatType = dictionary[K.CHAT_TYPE] as? String ?? ""
        
        self.groupImageLogoURL = URL(string: self.groupImageLogo)
        
        if self.chatType == ChatType.personal.type {
            self.chatTypes = .personal
        }else if self.chatType == ChatType.group.type {
            self.chatTypes = .group
        }else {
            self.chatTypes = .personal
        }
    }
    
    init(createdAt:String, groupId:String, chatType:String, groupImageLogo:String, groupName:String) {
        
        self.createdAt = createdAt
        self.groupId = groupId
        self.chatType = chatType
        self.groupImageLogo = groupImageLogo
        self.groupName = groupName
        
        self.groupImageLogoURL = URL(string: groupImageLogo)
        
        if chatType == ChatType.personal.type {
            self.chatTypes = .personal
        }else if chatType == ChatType.group.type {
            self.chatTypes = .group
        }else {
            self.chatTypes = .personal
        }
    }
}
