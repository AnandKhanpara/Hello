//
//  MessageVC.swift
//  Hello
//
//  Created by ZerOnes on 22/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation

class MessageVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblNVTitle: UILabel!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var tvPersonalMessages: UITableView!
    @IBOutlet weak var viewTopDividerLine: UIView!
    @IBOutlet weak var viewGroupInformation: UIView!
    
    @IBOutlet weak var constraintTVBottom: NSLayoutConstraint!
    
    //MARK:- Variable
    
    var receiverUser = User()
    var group = Group()
    var chatType:ChatType = .personal
    
    var viewKeyboardSendMessage:SendMessageView?
    var viewMainViewSendMessage:SendMessageView?
    var arrPersonalMessage = [PersonalMessageDay]()
    var arrGroupMessage = [GroupMessageDay]()
    
    var isSenderStartMessage = false
    var isReceiverStartMessage = false
    var isTVScrollToBottom = true
    var videoPlayerLayer:AVPlayerLayer = AVPlayerLayer()
    var videoPlayer:AVPlayer = AVPlayer()
    var videoPlayerView = VideoPlayer()
    var videoPlayIcon:UIImageView = UIImageView()
    var viewMessageDetails = UIView()
    var messageDetailsVC = MessageDetailsVC()
    var selectIndexPath:IndexPath!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillSetUp()
    }
    
    //MARK:- View SetUp
    
    func viewDidSetUp() {
        
        self.viewTapEndEditing()
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageDetailsVC") as? MessageDetailsVC {
            self.messageDetailsVC = viewController
            self.viewMessageDetails = viewController.view
            self.viewMessageDetails.frame = self.view.bounds
            self.viewMessageDetails.isHidden = true
            self.view.addSubview(self.viewMessageDetails)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide), name: UIApplication.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIApplication.keyboardDidShowNotification, object: nil)
        
        if let view = self.customSendMessageView() as? SendMessageView {
            
            self.viewSendMessage.addSubview(view)
            view.addBounds(self.viewSendMessage)
            self.viewMainViewSendMessage = view
            
            if let view1 = self.customSendMessageView() as? SendMessageView {
                self.viewMainViewSendMessage?.txtFieldTypeAMessage.inputAccessoryView = view1
                self.viewKeyboardSendMessage = view1
            }
        }
        
        self.viewTopDividerLine.addGradiantLayer(GradiantColor.redBlue)
    }
    
    func viewWillSetUp() {
        
        if self.chatType == .personal {
            self.lblNVTitle.text = receiverUser.userName
            self.viewGroupInformation.isHidden = true
            self.wsFetchUserPersonalChatConversation()
        }else if self.chatType == .group {
            self.lblNVTitle.text = self.group.groupDetails.groupName
            self.viewGroupInformation.isHidden = false
            self.wsFetchGroupChatConversation()
        }
    }
    
    //MARK:- Action
    

    
    @IBAction func btnGroupInformation_touchUpInside(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as? CreateGroupVC {
            vc.group = self.group
            vc.isShowGroupDetails = true
            vc.messageVC = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBack_touchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Function
    
    func tvPersonalMessagesScrollToBottom(_ isAnimated:Bool = false) {
        if self.chatType == .personal {
            if self.arrPersonalMessage.count > 0 {
                let section = (self.arrPersonalMessage.count - 1)
                if self.arrPersonalMessage[section].messages.count > 0 {
                    let row = (self.arrPersonalMessage[section].messages.count - 1)
                    self.tvPersonalMessages.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: isAnimated)
                }
            }
        }
    }
    
    func tvGroupMessagesScrollToBottom(_ isAnimated:Bool = false) {
        if self.chatType == .group {
            if self.arrGroupMessage.count > 0 {
                let section = (self.arrGroupMessage.count - 1)
                if self.arrGroupMessage[section].messages.count > 0 {
                    let row = (self.arrGroupMessage[section].messages.count - 1)
                    self.tvPersonalMessages.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: isAnimated)
                }
            }
        }
    }
    
    
    //MARK:- Web Service
    
    func wsImageUploadInFirebaseStorage(name imageName:String, _ image:UIImage, complition: @escaping (String, CGSize) -> ()) {
        
        guard let imageData = image.pngData() else { return }
        
        if self.chatType == .personal {
            
            let storage = StorageReference.child(FBStorageChild.personalChatImage.isNothing()).child(imageName.isNothing())
            
            storage.putData(imageData, metadata: nil) { (metadata, error) in
                if error == nil {
                    storage.downloadURL { (url, error) in
                        if error == nil, let url = url {
                            complition(String(describing: url), image.size)
                        }
                    }
                }
            }
        }else if self.chatType == .group {
            
            let storage = StorageReference.child(FBStorageChild.groupChatImage.isNothing()).child(imageName.isNothing())
            
            storage.putData(imageData, metadata: nil) { (metadata, error) in
                if error == nil {
                    storage.downloadURL { (url, error) in
                        if error == nil, let url = url {
                            complition(String(describing: url), image.size)
                        }
                    }
                }
            }
        }
    }
    
    func wsVideoUploadInFirebaseStorage(name videoName:String, videoURL url:URL, complition: @escaping (String) -> ()) {
        url.fileURLWithPath { (data) in
            if let data = data {
                
                if self.chatType == .personal {
                    
                    let storage = StorageReference.child(FBStorageChild.personalChatVideo.isNothing()).child(videoName.isNothing() + ".mp4")
                    storage.putData(data, metadata: nil) { (metadata, error) in
                        if error == nil {
                            storage.downloadURL { (url, error) in
                                if error == nil, let url = url {
                                    complition(String(describing: url))
                                }
                            }
                        }
                    }
                }else if self.chatType == .group {
                    
                    let storage = StorageReference.child(FBStorageChild.groupChatVideo.isNothing()).child(videoName.isNothing()  + ".mp4")
                    storage.putData(data, metadata: nil) { (metadata, error) in
                        if error == nil {
                            storage.downloadURL { (url, error) in
                                if error == nil, let url = url {
                                    complition(String(describing: url))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func wsSendMessage(createdAt time:String? = nil, message text:String = "", image:String = "", video:String = "", imageSize:CGSize? = nil, address:String = "", latitude:String = "", longitude:String = "", type:MessageType) {
        
        self.isTVScrollToBottom = true
        
        let messageDate = Date().changeDateFormate("yyyy-MM-dd")
        
        guard messageDate.isEmptyyy() == false else { return }
        
        let groupId = self.group.groupDetails.groupId
        let groupName = self.group.groupDetails.groupName
        let groupImageLogo = self.group.groupDetails.groupImageLogo
        let senderName = UserFetch.getSIData().userName
        let senderProfile = UserFetch.getSIData().profile
        
        let uId = UUID().uuidString
        var createdAt = Date().gmtZeroTime()
        let uIdSender = UserFetch.getSIData().uId
        let uIdReceiver = self.receiverUser.uId
        let uIdPersonalChat = UserSet.makeUIDCombination(firstId: uIdSender, secondId: uIdReceiver)
        
        if let time = time {
            createdAt = time
        }
        
        var message = [K.UID : uId,
                       K.CREATEDAT : createdAt,
                       K.SENDER : uIdSender,
                       K.MESSAGE_TYPE : type.type]
        
        if self.chatType == .personal {
            message[K.RECEIVER] = uIdReceiver
            message[K.MESSAGE_IS_RECEIVER_DELETE] = "0"
            message[K.MESSAGE_IS_SENDER_DELETE] = "0"
        }else if self.chatType == .group {
            message[K.GROUP_ID] = groupId
            message[K.SENDER_NAME] = senderName
            message[K.PROFILE] = senderProfile
        }
        
        if type == .text {
            message[K.MESSAGE_TEXT] = text
        }else if let size = imageSize, type == .image {
            message[K.MESSAGE_IMAGE] = image
            message[K.MESSAGE_IMAGE_HEIGHT] = "\(size.height)"
            message[K.MESSAGE_IMAGE_WIDTH] = "\(size.width)"
        }else if let size = imageSize, type == .video {
            message[K.MESSAGE_VIDEO_THUMBNAIL] = image
            message[K.MESSAGE_IMAGE_HEIGHT] = "\(size.height)"
            message[K.MESSAGE_IMAGE_WIDTH] = "\(size.width)"
            message[K.MESSAGE_VIDEO] = video
        }else if type == .location {
            message[K.MESSAGE_ADDRESS] = address
            message[K.MESSAGE_LATITUDE] = latitude
            message[K.MESSAGE_LONGITUDE] = longitude
        }else {
            return
        }
        
        if self.chatType == .personal {
            DataReference.child(FBChild.personalChatMessages.isNothing()).child(uIdPersonalChat.isNothing()).child(messageDate.isNothing()).child(uId.isNothing()).setValue(message)
        }else if self.chatType == .group {
            DataReference.child(FBChild.groupChatMessages.isNothing()).child(groupId.isNothing()).child(messageDate.isNothing()).child(uId.isNothing()).setValue(message)
        }
        
        var lastMessage = [K.CREATEDAT : createdAt,
                           K.SENDER : uIdSender,
                           K.MESSAGE_TYPE : type.type]
        
        if self.chatType == .personal {
            lastMessage[K.RECEIVER] = uIdReceiver
            lastMessage[K.UID] = uIdPersonalChat
            lastMessage[K.CHAT_TYPE] = ChatType.personal.type
        }else if self.chatType == .group {
            lastMessage[K.GROUP_ID] = groupId
            lastMessage[K.GROUP_NAME] = groupName
            lastMessage[K.GROUP_IMAGE_LOGO] = groupImageLogo
            lastMessage[K.CHAT_TYPE] = ChatType.group.type
        }
        
        if type == .text {
            lastMessage[K.MESSAGE_TEXT] = text
        }else if type == .location {
            lastMessage[K.MESSAGE_TEXT] = address
        }
        
        if self.chatType == .personal {
            self.wsLastChatMessages(message: lastMessage, uIdPersonalChat : uIdPersonalChat)
        }else if self.chatType == .group {
            self.wsLastGroupMessage(message: lastMessage, groupId: groupId)
        }
    }
    
    func wsLastGroupMessage(message:[String : String], groupId:String) {
        DataReference.child(FBChild.createGroupChat.isNothing()).child(groupId.isNothing()).child(K.GROUP_LAST_MESSAGE.isNothing()).setValue(message)
    }
    
    func wsLastChatMessages(message:[String : String], uIdPersonalChat:String = "") {
        self.wsLastChatMessagesSenderUpdate(message: message, uIdPersonalChat : uIdPersonalChat)
        self.wsLastChatMessagesReceiverUpdate(message: message, uIdPersonalChat : uIdPersonalChat)
    }
    
    func wsLastChatMessagesSenderUpdate(message:[String : String], uIdPersonalChat:String) {
        var lastMessage = message
        lastMessage[K.USERNAME] = self.receiverUser.userName
        lastMessage[K.PROFILE] = self.receiverUser.profile
        
        let uIdSender = message[K.SENDER] ?? ""
        
        DataReference.child(FBChild.lastChatMessages.isNothing()).child(uIdSender.isNothing()).child(uIdPersonalChat.isNothing()).setValue(lastMessage)
    }
    
    func wsLastChatMessagesReceiverUpdate(message:[String : String], uIdPersonalChat:String) {
        var lastMessage = message
        lastMessage[K.USERNAME] = UserFetch.getSIData().userName
        lastMessage[K.PROFILE] = UserFetch.getSIData().profile
        
        let uIdReceiver = message[K.RECEIVER] ?? ""
        
        DataReference.child(FBChild.lastChatMessages.isNothing()).child(uIdReceiver.isNothing()).child(uIdPersonalChat.isNothing()).setValue(lastMessage)
    }
    
    func wsDeleteMessage(indexPath:IndexPath) {
        
            self.isTVScrollToBottom = false
            
        let uIdSender = UserFetch.getSIData().uId
        
        if self.chatType == .personal {
            
            
            let uIdReceiver = self.receiverUser.uId
            let uIdPersonalChat = UserSet.makeUIDCombination(firstId: uIdSender, secondId: uIdReceiver)
            let sectionMessage = self.arrPersonalMessage[indexPath.section]
            let selectMessage = sectionMessage.messages[indexPath.row]
            
            let path = DataReference.child(FBChild.personalChatMessages.isNothing()).child(uIdPersonalChat.isNothing()).child(sectionMessage.date.isNothing())
            
            if uIdSender == selectMessage.sender {
                let deleteLevele = selectMessage.messageIsSenderDelete == "0" ? "1" : "2"
                path.child(selectMessage.uId.isNothing()).updateChildValues([K.MESSAGE_IS_SENDER_DELETE : deleteLevele])
            }else {
                let deleteLevele = selectMessage.messageIsReceiverDelete == "0" ? "1" : "2"
                path.child(selectMessage.uId.isNothing()).updateChildValues([K.MESSAGE_IS_RECEIVER_DELETE : deleteLevele])
            }
            
        }else if self.chatType == .group {
            
            let groupId = self.group.groupDetails.groupId
            let sectioMessage = self.arrGroupMessage[indexPath.section]
            let selectMessage = sectioMessage.messages[indexPath.row]
            let groupMessageDeletedUser = selectMessage.groupMessageDeletedUser
            let user = groupMessageDeletedUser[UserFetch.getSIData().uId] as? NSDictionary ?? NSDictionary()
            let userDeleteStatus = user[UserFetch.getSIData().uId] as? String ?? "0"
            let changeStatus = userDeleteStatus == "0" ? "1" : userDeleteStatus == "1" ? "2" : "2"
            let groupMessage = DataReference.child(FBChild.groupChatMessages.isNothing()).child(groupId.isNothing()).child(sectioMessage.date.isNothing()).child(selectMessage.uId.isNothing())
            groupMessage.child(K.GROUP_MESSAGE_DELETED_USER.isNothing()).child(uIdSender.isNothing()).setValue([uIdSender : changeStatus])
            
        }
        
            
       
    }
    
    func wsFetchGroupChatConversation() {
        let groupId = self.group.groupDetails.groupId
        DataReference.child(FBChild.groupChatMessages.isNothing()).child(groupId.isNothing()).observe(.value) { (conversations) in
            if self.chatType == .group {
                DispatchQueue.main.async {
                    if let conversations = conversations.value as? NSDictionary {
                        print(conversations)
                        self.arrGroupMessage = conversations.map({ GroupMessageDay(date: $0, messages: $1) }).sorted(by: {$0.date < $1.date})
                        self.tvPersonalMessages.reloadData()
                        if self.isTVScrollToBottom == true {
                            self.isTVScrollToBottom = false
                            self.tvGroupMessagesScrollToBottom()
                        }
                    }else {
                        self.arrPersonalMessage.removeAll()
                        self.tvPersonalMessages.reloadData()
                    }
                }
            }
        }
    }
    
    func wsFetchUserPersonalChatConversation() {
        let uIdSender = UserFetch.getSIData().uId
        let uIdReceiver = self.receiverUser.uId
        let uIdPersonalChat = UserSet.makeUIDCombination(firstId: uIdSender, secondId: uIdReceiver)
        DataReference.child(FBChild.personalChatMessages.isNothing()).child(uIdPersonalChat.isNothing()).observe(.value) { (conversations) in
            if self.chatType == .personal {
                DispatchQueue.main.async {
                    if let conversations = conversations.value as? NSDictionary {
                        print(conversations)
                        self.arrPersonalMessage = conversations.map({ PersonalMessageDay(date: $0, messages: $1) }).sorted(by: {$0.date < $1.date})
                        self.tvPersonalMessages.reloadData()
                        if self.isTVScrollToBottom == true {
                            self.isTVScrollToBottom = false
                            self.tvPersonalMessagesScrollToBottom()
                        }
                    }else {
                        self.arrPersonalMessage.removeAll()
                        self.tvPersonalMessages.reloadData()
                    }
                }
            }
        }
    }
}

//MARK:- Extension

extension MessageVC: UIToolbarDelegate, UITextFieldDelegate {
    
    @objc func keyboardDidShow(notification:Notification) {
        if let frame = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect {
            self.constraintTVBottom.constant = (frame.height - (50 + (App.window?.safeAreaInsets.bottom ?? 0)))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                if self.chatType == .personal {
                    self.tvPersonalMessagesScrollToBottom(true)
                }else if self.chatType == .group {
                    self.tvGroupMessagesScrollToBottom(true)
                }
            }
        }
    }
    
    @objc func keyboardShow(notification:Notification) {
        self.viewKeyboardSendMessage?.txtFieldTypeAMessage.becomeFirstResponder()
        self.viewKeyboardSendMessage?.txtFieldTypeAMessage.text = self.viewMainViewSendMessage?.txtFieldTypeAMessage.text
        
    }
    
    @objc func keyboardHide(notification:Notification) {
        self.constraintTVBottom.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.viewKeyboardSendMessage?.alpha = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.viewKeyboardSendMessage?.alpha = 1
        }
    }
    
    //MARK: Message Send Field And Custom View
    
    func customSendMessageView() -> UIView? {
        
        guard let addSendMessageView = (Bundle.main.loadNibNamed("SendMessageView", owner: nil, options: nil))?.first as? SendMessageView else {
            return UIView()
        }
        addSendMessageView.viewTopSeperatorLine.addGradiantLayer(GradiantColor.redBlue)
        addSendMessageView.txtFieldTypeAMessage.delegate = self
        addSendMessageView.viewFolder.isHidden = true
        
        addSendMessageView.txtFieldTypeAMessage.addTarget(self, action: #selector(self.txtFieldTypeAMessage_editingChange), for: .editingChanged)
        addSendMessageView.btnSend.addTarget(self, action: #selector(self.btnSendMessage_touchUpInside), for: .touchUpInside)
        addSendMessageView.btnFolder.addTarget(self, action: #selector(self.btnFolder_touchUpInside), for: .touchUpInside)
        addSendMessageView.btnKeyboard.addTarget(self, action: #selector(self.btnKeyboard_touchUpInside), for: .touchUpInside)
        addSendMessageView.btnVideo.addTarget(self, action: #selector(self.btnVideo_touchUpInside), for: .touchUpInside)
        addSendMessageView.btnCamera.addTarget(self, action: #selector(self.btnCamera_touchUpInside), for: .touchUpInside)
        addSendMessageView.btnGallery.addTarget(self, action: #selector(self.btnGallery_touchUpInside), for: .touchUpInside)
        addSendMessageView.btnLocation.addTarget(self, action: #selector(self.btnLocation_touchUpInside), for: .touchUpInside)
        
        return addSendMessageView
    }
    
    @objc func txtFieldTypeAMessage_editingChange(sender:UITextField) {
        self.viewKeyboardSendMessage?.txtFieldTypeAMessage.text = sender.text
        self.viewMainViewSendMessage?.txtFieldTypeAMessage.text = sender.text
    }
    
    @objc func btnFolder_touchUpInside(sender:UIButton) {
        self.viewMainViewSendMessage?.viewFolder.isHidden = false
        self.viewKeyboardSendMessage?.viewFolder.isHidden = false
    }
    
    @objc func btnKeyboard_touchUpInside(sender:UIButton) {
        self.viewMainViewSendMessage?.viewFolder.isHidden = true
        self.viewKeyboardSendMessage?.viewFolder.isHidden = true
    }
    
    @objc func btnGallery_touchUpInside(sender:UIButton) {
        self.openPickerView(source: .photoLibrary)
    }
    
    @objc func btnCamera_touchUpInside(sender:UIButton) {
        self.openPickerView(source: .camera)
    }
    
    @objc func btnVideo_touchUpInside(sender:UIButton) {
        self.openPickerView(source: .camera, mode: .video)
    }
    
    @objc func btnLocation_touchUpInside(sender:UIButton) {
        self.view.endEditing(true)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as? LocationVC {
            vc.delegate = self
            vc.isShowLocation = false
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func btnSendMessage_touchUpInside(sender:UIButton) {
        
        guard let text = self.viewMainViewSendMessage?.txtFieldTypeAMessage.text, text.isEmptyyy() == false else {
            ActivityClick.addAlert(Title: "Type A Message .....", type: .error)
            return
        }
        
        //self.view.endEditing(true)
        
        let messageText = self.viewMainViewSendMessage?.txtFieldTypeAMessage.text ?? ""
        
        self.wsSendMessage(message: messageText, type: .text)
        
        self.viewMainViewSendMessage?.txtFieldTypeAMessage.text = ""
        self.viewKeyboardSendMessage?.txtFieldTypeAMessage.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.viewKeyboardSendMessage?.txtFieldTypeAMessage.resignFirstResponder()
        self.viewMainViewSendMessage?.txtFieldTypeAMessage.resignFirstResponder()
        return true
    }
}

extension MessageVC : ShareLocationDelegate {
    
    func locationAddress(latitude: Double, longitude: Double, address: String) {
        let strLatitude = String(latitude)
        let strLongitude = String(longitude)
        let createdAt = Date().gmtZeroTime()
        self.wsSendMessage(createdAt: createdAt, address: address, latitude: strLatitude, longitude: strLongitude, type: .location)
    }
}

extension MessageVC : VideoPlayerDelegate {
    
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
        self.removeVideoPlayer()
        self.videoPlayIcon.isHidden = false
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

extension MessageVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openPickerView(source:UIImagePickerController.SourceType, mode:UIImagePickerController.CameraCaptureMode = .photo) {
        
        self.view.endEditing(true)
        
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true && source == .camera {
            picker.sourceType = .camera
            if mode == .video {
                picker.mediaTypes = ["public.movie"]
                picker.cameraCaptureMode = .video
                picker.videoQuality = .typeMedium
                picker.videoMaximumDuration = 10
            }
        }else {
            picker.sourceType = .photoLibrary
            picker.mediaTypes = ["public.image", "public.movie"]
        }
        //picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let resizeImage = image.resize(image.size, base: 350) {
                self.sendImageMessage(image: resizeImage)
            }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let resizeImage = image.resize(image.size, base: 350) {
                self.sendImageMessage(image: resizeImage)
            }else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print(videoURL)
                self.sendVideoMessage(videoURL: videoURL)
            }
        }
    }
    
    func sendImageMessage(image:UIImage) {
        let makeId = UserSet.makeUIDCombination(firstId: UserFetch.getSIData().uId, secondId: self.receiverUser.uId )
        let groupId = self.group.groupDetails.groupId
        let uIdSender = UserFetch.getSIData().uId
        let date = Date()
        let createdAt = date.gmtZeroTime()
        var imageName = ""
        if self.chatType == .personal {
            imageName = "\(makeId)_\(date.timeString())"
        }else if self.chatType == .group {
            imageName = "\(groupId)_\(uIdSender)_\(date.timeString())"
        }
        self.wsImageUploadInFirebaseStorage(name: imageName, image) { (imageUrl, imageSize) in
            self.wsSendMessage(createdAt: createdAt, image: imageUrl, imageSize: imageSize, type: .image)
        }
    }
    
    func sendVideoMessage(videoURL:URL) {
        
        if let imageThumbnail = videoURL.createThumbnailOfVideoFromRemoteUrl(), let thumbnail = imageThumbnail.resize(imageThumbnail.size, base: 350) {
            let makeId = UserSet.makeUIDCombination(firstId: UserFetch.getSIData().uId, secondId: self.receiverUser.uId )
            let groupId = self.group.groupDetails.groupId
            let uIdSender = UserFetch.getSIData().uId
            let date = Date()
            let createdAt = date.gmtZeroTime()
            var imageName = ""
            var videoName = ""
            
            if self.chatType == .personal {
                imageName = "\(makeId)_\(date.timeString())"
                videoName = "\(makeId)_\(date.timeString())"
            }else if self.chatType == .group {
                imageName = "\(groupId)_\(uIdSender)_\(date.timeString())"
                videoName = "\(groupId)_\(uIdSender)_\(date.timeString())"
            }
            
            self.wsImageUploadInFirebaseStorage(name: imageName, thumbnail) { (imageUrl, imageSize) in
                self.wsVideoUploadInFirebaseStorage(name: videoName, videoURL: videoURL) { (videoURLPath) in
                    self.wsSendMessage(createdAt: createdAt, image: imageUrl, video: videoURLPath, imageSize: imageSize, type: .video)
                }
            }
        }
    }
}

extension MessageVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.chatType == .personal {
            return self.arrPersonalMessage.count
        }else if self.chatType == .group {
            return self.arrGroupMessage.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("MessageDayHeaderView", owner: nil, options: nil)?.first as? MessageDayHeaderView
        if self.chatType == .personal {
            headerView?.lblDayDate.text = self.arrPersonalMessage[section].date.messageDayDateFormatter()
        }else if self.chatType == .group {
            headerView?.lblDayDate.text = self.arrGroupMessage[section].date.messageDayDateFormatter()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.chatType == .personal {
            if self.arrPersonalMessage[section].messages.count == 0 {
                return 0
            }
            return 50
        }else if self.chatType == .group {
            if self.arrGroupMessage[section].messages.count == 0 {
                return 0
            }
            return 50
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.chatType == .personal {
            if section == (self.arrPersonalMessage.count - 1) {
                return 20
            }else {
                return 0
            }
        }else if self.chatType == .group {
            if section == (self.arrGroupMessage.count - 1) {
                return 20
            }else {
                return 0
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.chatType == .personal {
            return self.arrPersonalMessage[section].messages.count
        }else if self.chatType == .group {
            return self.arrGroupMessage[section].messages.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.removeVideoPlayer()
        self.videoPlayIcon.isHidden = false
        
        if self.chatType == .personal {
            
            let message = self.arrPersonalMessage[indexPath.section].messages[indexPath.row]
            
            if (message.sender == UserFetch.getSIData().uId && message.isMessageSenderDelete == true) {
                return self.messageDeleteSenderTVCell(message, indexPath: indexPath)
                
            }else if (message.receiver == UserFetch.getSIData().uId && message.isMessageReceiverDelete == true) {
                return self.messageDeleteReceiverTVCell(message, indexPath: indexPath)
                
            }else if message.type == .text {
                
                if message.sender == UserFetch.getSIData().uId  {
                    return self.messageTextSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.messageTextReceiverTVCell(message, indexPath: indexPath)
                }
                
            }else if message.type == .image {
                if message.sender == UserFetch.getSIData().uId  {
                    return self.messageImageSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.messageImageReceiverTVCell(message, indexPath: indexPath)
                }
                
            }else  if message.type == .location {
                if message.sender == UserFetch.getSIData().uId {
                    return self.messageLocationSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.messageLocationReceiverTVCell(message, indexPath: indexPath)
                }
                
            }else  if message.type == .video {
                if message.sender == UserFetch.getSIData().uId  {
                    return self.messageVideoSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.messageVideoReceiverTVCell(message, indexPath: indexPath)
                }
                
            }else {
                if message.sender == UserFetch.getSIData().uId  {
                    return self.messageTextSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.messageTextReceiverTVCell(message, indexPath: indexPath)
                }
            }
            
        }else if self.chatType == .group {
            
            let message = self.arrGroupMessage[indexPath.section].messages[indexPath.row]
            
            if (message.sender == UserFetch.getSIData().uId && message.isMessageUserDelete == true) {
                return self.groupMessageDeleteSenderTVCell(message, indexPath: indexPath)
                
            }else if (message.sender != UserFetch.getSIData().uId && message.isMessageUserDelete == true) {
                return self.groupMessageDeleteReceiverTVCell(message, indexPath: indexPath)
                
            }else if message.type == .text {
                if message.sender == UserFetch.getSIData().uId  {
                    return self.groupMessageTextSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.groupMessageTextReceiverTVCell(message, indexPath: indexPath)
                }
            }else if message.type == .image {
                if message.sender == UserFetch.getSIData().uId  {
                    return self.groupMessageImageSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.groupMessageImageReceiverTVCell(message, indexPath: indexPath)
                }
                
            }else  if message.type == .location {
                if message.sender == UserFetch.getSIData().uId {
                    return self.groupMessageLocationSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.groupMessageLocationReceiverTVCell(message, indexPath: indexPath)
                }
                
            }else  if message.type == .video {
                if message.sender == UserFetch.getSIData().uId  {
                    return self.groupMessageVideoSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.groupMessageVideoReceiverTVCell(message, indexPath: indexPath)
                }
                
            }else {
                if message.sender == UserFetch.getSIData().uId  {
                    return self.groupMessageTextSenderTVCell(message, indexPath: indexPath)
                }else {
                    return self.groupMessageTextReceiverTVCell(message, indexPath: indexPath)
                }
            }
            
        }else {
            
            let message = self.arrPersonalMessage[indexPath.section].messages[indexPath.row]
            
            if message.sender == UserFetch.getSIData().uId  {
                return self.messageTextSenderTVCell(message, indexPath: indexPath)
            }else {
                return self.messageTextReceiverTVCell(message, indexPath: indexPath)
            }
        }
        
        
        
    }
    
    //MARK: Message - cellForRow
    
    func messageTextSenderTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageTextSenderTVCell", for: indexPath) as! MessageTextSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = UserFetch.getSIData()
        return cell
    }
    
    func messageTextReceiverTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageTextReceiverTVCell", for: indexPath) as! MessageTextReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = self.receiverUser
        return cell
    }
    
    func messageDeleteReceiverTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageDeleteReceiverTVCell", for: indexPath) as! MessageDeleteReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = self.receiverUser
        return cell
    }
    
    func messageDeleteSenderTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageDeleteSenderTVCell", for: indexPath) as! MessageDeleteSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = UserFetch.getSIData()
        return cell
    }
    
    func messageImageSenderTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageImageSenderTVCell", for: indexPath) as! MessageImageSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = UserFetch.getSIData()
        return cell
    }
    
    func messageImageReceiverTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageImageReceiverTVCell", for: indexPath) as! MessageImageReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = self.receiverUser
        return cell
    }
    
    func messageLocationSenderTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageLocationSenderTVCell", for: indexPath) as! MessageLocationSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = UserFetch.getSIData()
        return cell
    }
    
    func messageLocationReceiverTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageLocationReceiverTVCell", for: indexPath) as! MessageLocationReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = self.receiverUser
        return cell
    }
    
    func messageVideoSenderTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageVideoSenderTVCell", for: indexPath) as! MessageVideoSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = UserFetch.getSIData()
        return cell
    }
    
    func messageVideoReceiverTVCell(_ message:PersonalMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "MessageVideoReceiverTVCell", for: indexPath) as! MessageVideoReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        cell.profile = self.receiverUser
        return cell
    }
    
    func groupMessageTextSenderTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageTextSenderTVCell", for: indexPath) as! GroupMessageTextSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageTextReceiverTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageTextReceiverTVCell", for: indexPath) as! GroupMessageTextReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageDeleteReceiverTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageDeleteReceiverTVCell", for: indexPath) as! GroupMessageDeleteReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageDeleteSenderTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageDeleteSenderTVCell", for: indexPath) as! GroupMessageDeleteSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageImageSenderTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageImageSenderTVCell", for: indexPath) as! GroupMessageImageSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageImageReceiverTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageImageReceiverTVCell", for: indexPath) as! GroupMessageImageReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageLocationSenderTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageLocationSenderTVCell", for: indexPath) as! GroupMessageLocationSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageLocationReceiverTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageLocationReceiverTVCell", for: indexPath) as! GroupMessageLocationReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageVideoSenderTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageVideoSenderTVCell", for: indexPath) as! GroupMessageVideoSenderTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    func groupMessageVideoReceiverTVCell(_ message:GroupMessage, indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tvPersonalMessages.dequeueReusableCell(withIdentifier: "GroupMessageVideoReceiverTVCell", for: indexPath) as! GroupMessageVideoReceiverTVCell
        cell.message = message
        cell.parent = self
        cell.indexPath = indexPath
        return cell
    }
    
    //MARK: TableView Action
    
    @objc func viewSelectProfile_tapGesture(gesture:UITapGestureRecognizer) {
        let viewSelectPoint = gesture.location(in: self.tvPersonalMessages)
        let indexPathView = self.tvPersonalMessages.indexPathForRow(at: viewSelectPoint)
        if let indexPath = indexPathView {
            let alert = UIAlertController(title: "Delete Message", message: "", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
                self.wsDeleteMessage(indexPath: indexPath)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(confirm)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func viewSelectMessage_tapGesture(gesture:UITapGestureRecognizer) {
        
        func showLocationDetails(personalMessage:PersonalMessage? = nil, groupMessage:GroupMessage? = nil) {
            self.isTVScrollToBottom = false
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as? LocationVC {
                vc.delegate = self
                vc.isShowLocation = true
                vc.personalMessage = personalMessage
                vc.groupMessage = groupMessage
                vc.chatType = self.chatType
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        func videoPlaying() -> Bool {
            return (self.videoPlayer.error == nil && self.videoPlayer.rate != 0)
        }
        
        let viewSelectPoint = gesture.location(in: self.tvPersonalMessages)
        
        if let indexPath = self.tvPersonalMessages.indexPathForRow(at: viewSelectPoint) {
            
            var messageType:MessageType = .text
            var personalMessage = PersonalMessage()
            var groupMessage = GroupMessage()
            guard var videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
            
            if self.chatType == .personal {
                personalMessage = self.arrPersonalMessage[indexPath.section].messages[indexPath.row]
                messageType = personalMessage.type
                if let url = personalMessage.messageVideoURL {
                    videoURL = url
                }
            }else if self.chatType == .group {
                groupMessage = self.arrGroupMessage[indexPath.section].messages[indexPath.row]
                messageType = groupMessage.type
                if let url = groupMessage.messageVideoURL {
                    videoURL = url
                }
            }
            
            if messageType == .video {
                
                if let messageVideoSenderTVCell = self.tvPersonalMessages.cellForRow(at: indexPath) as? MessageVideoSenderTVCell {
                    messageVideoSenderTVCell.imgViewPlayIcon.isHidden = !videoPlaying()
                    if videoPlaying() == true {
                        self.removeVideoPlayer()
                    }else {
                        self.videoLayer(videoURL: videoURL, viewLayer: messageVideoSenderTVCell.imgViewVideoThumbnail)
                    }
                    self.videoPlayIcon = messageVideoSenderTVCell.imgViewPlayIcon
                    
                }else if let messageVideoReceiverTVCell = self.tvPersonalMessages.cellForRow(at: indexPath) as? MessageVideoReceiverTVCell {
                    messageVideoReceiverTVCell.imgViewPlayIcon.isHidden = !videoPlaying()
                    if videoPlaying() == true {
                        self.removeVideoPlayer()
                    }else {
                        self.videoLayer(videoURL: videoURL, viewLayer: messageVideoReceiverTVCell.imgViewVideoThumbnail)
                    }
                    self.videoPlayIcon = messageVideoReceiverTVCell.imgViewPlayIcon
                    
                }else if let groupMessageVideoSenderTVCell = self.tvPersonalMessages.cellForRow(at: indexPath) as? GroupMessageVideoSenderTVCell {
                    groupMessageVideoSenderTVCell.imgViewPlayIcon.isHidden = !videoPlaying()
                    if videoPlaying() == true {
                        self.removeVideoPlayer()
                    }else {
                        self.videoLayer(videoURL: videoURL, viewLayer: groupMessageVideoSenderTVCell.imgViewVideoThumbnail)
                    }
                    self.videoPlayIcon = groupMessageVideoSenderTVCell.imgViewPlayIcon
                    
                }else if let groupMessageVideoReceiverTVCell = self.tvPersonalMessages.cellForRow(at: indexPath) as? GroupMessageVideoReceiverTVCell {
                    groupMessageVideoReceiverTVCell.imgViewPlayIcon.isHidden = !videoPlaying()
                    if videoPlaying() == true {
                        self.removeVideoPlayer()
                    }else {
                        self.videoLayer(videoURL: videoURL, viewLayer: groupMessageVideoReceiverTVCell.imgViewVideoThumbnail)
                    }
                    self.videoPlayIcon = groupMessageVideoReceiverTVCell.imgViewPlayIcon
                }
                
            }else if messageType == .location {
                showLocationDetails(personalMessage: personalMessage, groupMessage: groupMessage)
            }
        }
    }
    
    
    @objc func viewSelectMessage_longGesture(gesture:UILongPressGestureRecognizer) {
        let viewSelectPoint = gesture.location(in: self.tvPersonalMessages)
        guard let indexPath = self.tvPersonalMessages.indexPathForRow(at: viewSelectPoint) else { return }
        if gesture.state == .began {
            self.selectIndexPath = indexPath
            self.viewMessageDetails.isHidden = false
            if self.chatType == .personal {
                let message = self.arrPersonalMessage[self.selectIndexPath.section].messages[self.selectIndexPath.row]
                self.messageDetailsVC.showMessageDetails(personalMessage: message, chatType: .personal)
            }else if self.chatType == .group {
                let message = self.arrGroupMessage[self.selectIndexPath.section].messages[self.selectIndexPath.row]
                self.messageDetailsVC.showMessageDetails(groupMessage: message, chatType: .group)
            }
        }else if gesture.state == .ended {
            self.viewMessageDetails.isHidden = true
            if self.chatType == .personal {
                let message = self.arrPersonalMessage[self.selectIndexPath.section].messages[self.selectIndexPath.row]
                self.messageDetailsVC.hideMessageDetails(personalMessage: message, chatType: .personal)
            }else if self.chatType == .group {
                let message = self.arrGroupMessage[self.selectIndexPath.section].messages[self.selectIndexPath.row]
                self.messageDetailsVC.hideMessageDetails(groupMessage: message, chatType: .group)
            }
        }
    }
    
}
