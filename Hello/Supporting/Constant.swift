//
//  Constant.swift
//  Hello
//
//  Created by ZerOnes on 10/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//


import UIKit
import Firebase
import FirebaseStorage

//MARK:- Keys

class K: NSObject {
    static let UID = "uId"
    static let EMAIL = "email"
    static let PASSWORD = "password"
    static let USERNAME = "userName"
    static let PROFILE = "profile"
    static let CREATEDAT = "createdAt"
    static let SENDER = "sender"
    static let SENDER_NAME = "senderName"
    static let RECEIVER = "receiver"
    static let MESSAGE_TYPE = "messageType"
    static let MESSAGE_TEXT = "messageText"
    static let MESSAGE_IMAGE = "messageImage"
    static let MESSAGE_VIDEO = "messageVideo"
    static let MESSAGE_LATITUDE = "messageLatitude"
    static let MESSAGE_LONGITUDE = "messageLongitude"
    static let MESSAGE_ADDRESS = "messageAddress"
    static let MESSAGE_VIDEO_THUMBNAIL = "messageVideoThumbnail"
    static let MESSAGE_IMAGE_HEIGHT = "messageImageHeight"
    static let MESSAGE_IMAGE_WIDTH = "messageImageWidth"
    static let MESSAGE_READ = "messageRead"
    static let MESSAGE_IS_SENDER_DELETE = "messageIsSenderDelete"
    static let MESSAGE_IS_RECEIVER_DELETE = "messageIsReceiverDelete"
    static let ACCEPT_REQUEST = "acceptRequest"
    static let CHAT_TYPE = "chatType"
    static let GROUP_ID = "groupId"
    static let GROUP_MEMBER = "groupMember"
    static let GROUP_NAME = "groupName"
    static let GROUP_DETAILS = "groupDetails"
    static let GROUP_IMAGE_LOGO = "groupImageLogo"
    static let GROUP_LAST_MESSAGE = "groupLastMessage"
    static let GROUP_MESSAGE_DELETED_USER = "groupMessageDeletedUser"
    static let GROUP_ADMIN_MEMBERS = "groupAdminMembers"
    static let STATUS_ID = "statusId"
    static let STATUS_IMAGE = "statusImage"
    static let STATUS_IMAGE_HEIGHT = "statusImageHeight"
    static let STATUS_IMAGE_WIDTH = "statusImageWidth"
    static let STATUS_TYPE = "statusType"
    
    static let JOIN_FRIENDS_REQUEST_ID = "joinFriendsRequestId"
    static let US_USER_SIGNIN_STATUS = "us_user_signin_status"
    static let US_USER_SIGNIN_DATA = "us_user_signin_data"
}

//MARK:- Variable

let App :AppDelegate = UIApplication.shared.delegate as! AppDelegate
let UserStandard = UserDefaults.standard
let DataReference = Database.database().reference()
let StorageReference = Storage.storage().reference()


var parentHomeVC:HomeVC!
var parentAddFriendsVC:AddFriendsVC!
var parentStatusViewVC:StatusViewVC!
//MARK:- Firebase Table

class FBChild:NSObject {
    static let register = "Register"
    static let joinFriendsRequest = "JoinFriendsRequest"
    static let personalChatMessages = "PersonalChatMessages"
    static let lastChatMessages = "LastChatMessages"
    static let createGroupChat = "CreateGroupChat"
    static let groupChatMessages = "GroupChatMessages"
    static let userStatus = "UserStatus"
}

class FBStorageChild:NSObject {
    static let registerUserProfileImage = "Hello_Images_RegisterUserProfile"
    static let groupCreateLogoImage = "Hello_Images_GroupCreateLogo"
    static let personalChatImage = "Hello_Images_PersonalChat"
    static let groupChatImage = "Hello_Images_GroupChat"
    static let userStatusImage = "Hello_Images_UserStatus"
    static let personalChatVideo = "Hello_Videos_PersonalChat"
    static let groupChatVideo = "Hello_Videos_GrouplChat"

    //static let images = "Hello_Images"
    //static let videos = "Hello_Videos"
}



//FFF0E8 // R : 255 G : 240 B : 232

//MARK:- Enum

public enum ChatType {
    
    case personal
    case group
    
    var type: String {
        switch self {
        case .personal:
            return "personal"
        case .group:
            return "group"
        }
    }
}

public enum StatusType {
    
    case image
    case video
    
    var type: String {
        switch self {
        case .image:
            return "image"
        case .video:
            return "video"
        }
    }
}

public enum Status {
    case signUp
    case signIn
}

public enum MessageType {
    
    case text
    case image
    case video
    case location
    
    var type: String {
        switch self {
        case .text:
            return "text"
        case .image:
            return "image"
        case .video:
            return "video"
        case .location:
            return "location"
        }
    }
    
}


//MARK:- Struct

struct GradiantColor {
    static let redBlue = [UIColor.red.cgColor, UIColor.blue.cgColor]
}



