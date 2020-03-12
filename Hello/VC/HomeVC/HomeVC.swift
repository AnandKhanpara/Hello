//
//  HomeVC.swift
//  Hello
//
//  Created by ZerOnes on 18/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit


protocol UserDetailsDelegate {
    func userSelectedDetails(user:User)
}

class HomeVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var constraintViewFriendAndViewStatusTopToBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var constraintViewPlusAndViewFriendTopToBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var lblNVTitle: UILabel!
    @IBOutlet weak var lblRequestCount: UILabel!
    @IBOutlet weak var viewPlusShadow: UIView!
    @IBOutlet weak var viewFriendsShadow: UIView!
    @IBOutlet weak var viewStatusShadow: UIView!
    @IBOutlet weak var viewPlus: UIView!
    @IBOutlet weak var viewFriends: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewTopDividerLine: UIView!
    @IBOutlet weak var tvLastMessage: UITableView!
    
    //MARK:- Variable
    
    var arrLastMessages = [LastMessage]()
    var arrGroup = [Group]()
    var arrFetchStatus = [String]()
    var arrMyFriend = [User]()
    var arrUsersStatus = [UserStatus]()
    
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
        parentHomeVC = self
        self.viewTopDividerLine.addGradiantLayer(GradiantColor.redBlue)
        self.isShowPlusChange(duration: 0)
    }
    
    func viewWillSetUp() {
        self.lblNVTitle.text = "Hello, \(UserFetch.getSIData().userName)"
        self.wsJoinReceiverRequest()
        self.wsMyGroup { (arrGroupLastMessages) in
            self.wsLastChatMessages { (arrPersonalLastMessages) in
                self.arrLastMessages = (arrGroupLastMessages + arrPersonalLastMessages).sorted(by: {$0.createdAt > $1.createdAt })
                self.tvLastMessage.reloadData()
            }
        }
        
        AddFriendsVC.shared.wsGetAddFriends(isBackGround: true) {
            self.arrMyFriend = AddFriendsVC.shared.arrFriends
            self.arrMyFriend.insert(UserFetch.getSIData(), at: 0)
            //self.wsMyFriendsStatus()
            self.wsGetStatus()
        }
        
        self.shadowView(view: self.viewPlusShadow)
        self.shadowView(view: self.viewFriendsShadow)
        self.shadowView(view: self.viewStatusShadow)
    }
    
    //MARK:- Action
    
    @IBAction func btnPlus_touchUpInside(_ sender: UIButton) {
        self.isShowPlusChange(duration : 0.3)
    }
    
    @IBAction func btnFriends_touchUpInside(_ sender: UIButton) {
        self.isShowPlusChange(duration : 0.3)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendsVC") as? AddFriendsVC  {
            vc.delegate = self
            vc.isShowOnlyFriends = true
            vc.isPresentView = true
            vc.viewTitle = "Friends"
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnStatus_touchUpInside(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnMakeFriends_touchUpInside(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addFriendsSegue", sender: self)
    }
    
    @IBAction func btnSignOut_touchUpInside(_ sender: UIButton) {
        App.signOut()
    }
    
    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageSegue" {
            let send = segue.destination as! MessageVC
            if let user = sender as? User {
                send.chatType = .personal
                send.receiverUser = user
            }else if let group = sender as? Group {
                send.chatType = .group
                send.group = group
            }
        }
    }
    
    //MARK:- Function
    
    func showStatusView(index:Int, userStatus:UserStatus) {
        print(index)
        print(userStatus)
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewVC") as? StatusViewVC {
            vc.modalPresentationStyle = .fullScreen
            vc.arrUserStatus = self.arrUsersStatus
            vc.index = index
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func isShowPlusChange(duration:TimeInterval = 0.3) {
        if self.viewStatus.isHidden == true {
            
            self.constraintViewPlusAndViewFriendTopToBottomSpace.constant = -55
            self.constraintViewFriendAndViewStatusTopToBottomSpace.constant = -45
            self.viewFriendsShadow.isHidden = false
            self.viewStatusShadow.isHidden = false
            self.viewFriends.isHidden = false
            self.viewStatus.isHidden = false
            
            self.viewFriendsShadow.alpha = 0
            self.viewStatusShadow.alpha = 0
            self.viewFriends.alpha = 0
            self.viewStatus.alpha = 0
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                self.constraintViewPlusAndViewFriendTopToBottomSpace.constant = 20
                self.viewFriendsShadow.alpha = 1
                self.viewFriends.alpha = 1
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: duration, delay: duration / 2, options: .curveEaseOut, animations: {
                    self.constraintViewFriendAndViewStatusTopToBottomSpace.constant = 20
                    self.viewStatusShadow.alpha = 1
                    self.viewStatus.alpha = 1
                    self.view.layoutIfNeeded()
                })
            })
        }else {
            
            self.constraintViewPlusAndViewFriendTopToBottomSpace.constant = 20
            self.constraintViewFriendAndViewStatusTopToBottomSpace.constant = 20
            self.viewFriendsShadow.alpha = 1
            self.viewStatusShadow.alpha = 1
            self.viewFriends.alpha = 1
            self.viewStatus.alpha = 1
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                self.constraintViewFriendAndViewStatusTopToBottomSpace.constant = -45
                self.viewStatusShadow.alpha = 0
                self.viewStatus.alpha = 0
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: duration, delay: duration / 2, options: .curveEaseIn, animations: {
                    self.constraintViewPlusAndViewFriendTopToBottomSpace.constant = -55
                    self.viewFriends.alpha = 0
                    self.viewFriendsShadow.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.viewFriendsShadow.isHidden = true
                    self.viewStatusShadow.isHidden = true
                    self.viewFriends.isHidden = true
                    self.viewStatus.isHidden = true
                })
            })
        }
    }
    
    func shadowView(view:UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
            view.layer.shadowRadius = 15
            view.layer.shadowColor = UIColor.red.cgColor
            view.layer.shadowOffset = .zero
            view.layer.shadowOpacity = 0.3
        }
    }
    
    //MARK:- Web Service
    
    func wsGetStatus() {
        
        let numberOfFriends = self.arrMyFriend.count
        var arrUserStatus = [UserStatus]()
        var setNumberOfFriendsStatus = 0
        
        for friend in self.arrMyFriend {
            
            DataReference.child(FBChild.userStatus.isNothing()).child(friend.uId.isNothing()).observeSingleEvent(of: .value) { (ref) in
                
                DispatchQueue.main.async {
                    
                    setNumberOfFriendsStatus += 1
                                        
                    if let ref = ref.value as? NSDictionary, let allValue = ref.allValues as? [NSDictionary] {
                        
                        let arrStatus = allValue.map({ StatusDetails($0)}).filter { (status) -> Bool in
                            let time1 = status.createdAt.stringToDate()
                            let interval = time1.timeIntervalSince(Date())
                            return interval > -86400
                        }
                        
                        if let firstStatus = arrStatus.first {
                            var userStauts = UserStatus()
                            userStauts.userId = firstStatus.uId
                            userStauts.userName = firstStatus.userName
                            userStauts.userProfile = firstStatus.profile
                            if let urlProfile = URL(string: firstStatus.profile) {
                                userStauts.userProfileURL = urlProfile
                            }
                            userStauts.firstStatus = firstStatus
                            arrUserStatus.append(userStauts)
                        }
                        
                        let arrExpiryStatus = allValue.map({ StatusDetails($0)}).filter { (status) -> Bool in
                            let time1 = status.createdAt.stringToDate()
                            let interval = time1.timeIntervalSince(Date())
                            return interval < -86400
                        }
                        
                        for expiryStatus in arrExpiryStatus {
                            DataReference.child(FBChild.userStatus.isNothing()).child(expiryStatus.uId.isNothing()).child(expiryStatus.statusId.isNothing()).removeValue()
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        if numberOfFriends == setNumberOfFriendsStatus {
                            self.arrUsersStatus = arrUserStatus
                            self.tvLastMessage.reloadData()
                        }
                    }
                }
            }
        }
    }
        
    func wsImageUploadInFirebaseStorage(name imageName:String, _ image:UIImage, complition: @escaping (String, CGSize) -> ()) {
        
        guard let imageData = image.pngData() else { return }
        
        let storage = StorageReference.child(FBStorageChild.userStatusImage.isNothing()).child(imageName.isNothing())
        
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
    
    func wsAddStatus(image:UIImage, type:StatusType) {
        
        ActivityClick.startLoadingBar()
        
        let date = Date()
        let createdAt = date.gmtZeroTime()
        let statusUId = UUID().uuidString
        let imageName = "\(UserFetch.getSIData().uId)_\(statusUId)_\(date.timeString())"
        
        self.wsImageUploadInFirebaseStorage(name: imageName, image) { (imageURL, size) in
            
            var statusDetails = [K.CREATEDAT : createdAt,
                                 K.UID : UserFetch.getSIData().uId,
                                 K.USERNAME : UserFetch.getSIData().userName,
                                 K.PROFILE : UserFetch.getSIData().profile,
                                 K.STATUS_ID : statusUId,
                                 K.STATUS_IMAGE_HEIGHT : "\(size.height)",
                K.STATUS_IMAGE_WIDTH : "\(size.width)",
                K.STATUS_TYPE : type.type]
            
            if type == .image {
                statusDetails[K.STATUS_IMAGE] = imageURL
            }
            
            let status = DataReference.child(FBChild.userStatus.isNothing()).child(UserFetch.getSIData().uId.isNothing()).child(statusUId.isNothing())
            status.setValue(statusDetails) { (error, ref) in
                
                ActivityClick.stopLoadingBar()
                
                if error == nil {
                    ActivityClick.addAlert(Title: "Successfully Add Status", type: .success)
                }else {
                    ActivityClick.addAlert(Title: "Something, went wrong", type: .error)
                }
            }
        }
    }
    
    func wsMyGroup(_ complition : @escaping ([LastMessage]) -> ()) {
        let group = DataReference.child(FBChild.createGroupChat.isNothing()).queryOrdered(byChild: UserFetch.getSIData().uId).queryEqual(toValue: "1")
        group.observe(.value) { (refGroup) in
            if let groups = refGroup.value as? NSDictionary, let arrGroup = groups.allValues as? [NSDictionary] {
                
                let arrGroup = arrGroup.map({ Group($0) })
                var arrGroupLastMessages = [LastMessage]()
                for last in arrGroup {
                    arrGroupLastMessages.append(last.lastMessage)
                }
                self.arrGroup = arrGroup
                complition(arrGroupLastMessages)
            }else {
                self.arrGroup.removeAll()
                complition([LastMessage]())
            }
        }
    }
    
    func wsLastChatMessages (_ complition : @escaping ([LastMessage]) -> ()) {
        DataReference.child(FBChild.lastChatMessages.isNothing()).child(UserFetch.getSIData().uId.isNothing()).observe(.value) { (ref) in
            if let lastChat = ref.value as? NSDictionary, let lastMessages = lastChat.allValues as? [NSDictionary] {
                let arrLastMesages = lastMessages.map({ LastMessage($0) })
                complition(arrLastMesages)
            }else {
                complition([LastMessage]())
            }
        }
    }
    
    func wsJoinReceiverRequest() {
        let uIdReceiver = UserFetch.getSIData().uId
        let fetchJoinSenderRequest = DataReference.child(FBChild.joinFriendsRequest.isNothing()).queryOrdered(byChild: K.RECEIVER).queryEqual(toValue: uIdReceiver)
        fetchJoinSenderRequest.observe(.value) { (ref) in
            DispatchQueue.main.async {
                if let arrReceiver = ref.value as? NSDictionary, let arrReceiverValue = arrReceiver.allValues as? [NSDictionary] {
                    let count = arrReceiverValue.map({ JoinRequest($0) }).filter({ $0.acceptRequest == "0" }).count
                    self.lblRequestCount.isHidden = count > 0 ? false : true
                    self.lblRequestCount.text = "\(count)"
                }else {
                    self.lblRequestCount.isHidden = true
                }
            }
        }
    }
}

//MARK:- Extension

extension HomeVC: UserDetailsDelegate {
    
    func userSelectedDetails(user: User) {
        self.performSegue(withIdentifier: "messageSegue", sender: user)
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.arrUsersStatus.count > 0 ? 1 : 0
        }
        return self.arrLastMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tvLastMessage.dequeueReusableCell(withIdentifier: "UserStatusTVCell") as! UserStatusTVCell
            cell.cvUserStatus.reloadData()
            return cell
        }else {
            let cell = self.tvLastMessage.dequeueReusableCell(withIdentifier: "LastMessageTVCell") as! LastMessageTVCell
            cell.lastMessage = self.arrLastMessages[indexPath.row]
            cell.indexPath = indexPath
            cell.parent = self
            return cell
        }
    }
    
    @objc func btnSelectViewUser_touchUpInside(sender:UIButton) {
        let message = self.arrLastMessages[sender.tag % 10000000]
        if message.chatTypes == .personal {
            let uId = message.sender == UserFetch.getSIData().uId ? message.receiver : message.sender
            let user = User(email: "", password: "", uId: uId, userName: message.userName, createdAt: "", profile: message.profile)
            self.performSegue(withIdentifier: "messageSegue", sender: user)
        }else if message.chatTypes == .group {
            if let group = self.arrGroup.filter({ $0.groupDetails.groupId == message.groupId }).first {
                self.performSegue(withIdentifier: "messageSegue", sender: group)
            }
        }
    }
    
    //let index = sender.tag % 10000000
    //StatusViewVC
}

extension HomeVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let resizeImage = image.resize(image.size, base: 400) {
                self.wsAddStatus(image: resizeImage, type: .image)
            }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let resizeImage = image.resize(image.size, base: 400) {
                self.wsAddStatus(image: resizeImage, type: .image)
            }else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print(videoURL)
            }
        }
        
    }
    
}



/*
 
 Smith
 Brown
 Davis
 Jones
 Johnson
 Clark
 Williams
 Miller
 Wilson
 
 
 
 
 Mary
 Elizabeth
 Sarah
 Nancy
 Ann
 Catherine
 Margaret
 Jane
 Susan
 Hannah
 
 */
