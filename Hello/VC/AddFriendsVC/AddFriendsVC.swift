//
//  AddFriendsVC.swift
//  Hello
//
//  Created by ZerOnes on 18/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import SDWebImage

class AddFriendsVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblNVTitle: UILabel!
    @IBOutlet weak var tvAddFriends: UITableView!
    @IBOutlet weak var viewCreateGroup: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var viewTopDividerLine: UIView!
    
    //MARK:- Variable
    
    
    static let shared = AddFriendsVC()
    
    var arrSenderRequest = [JoinRequest]()
    var arrReceiverRequest = [JoinRequest]()
    var arrAllUserFriends = [User]()
    var arrFriends = [User]()
    var arrAddNewFriends = [User]()
    var arrReceiveRequestFriends = [User]()
    var arrPendingRequestFriends = [User]()
    var delegate:UserDetailsDelegate?
    var isPresentView = false
    var isShowOnlyFriends = false
    var viewTitle:String?
    
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
        parentAddFriendsVC = self
        self.viewTopDividerLine.addGradiantLayer(GradiantColor.redBlue)
    }
    
    func viewWillSetUp() {
        self.viewCreateGroup.isHidden = self.isPresentView
        self.viewBack.isHidden = self.isPresentView
        self.viewClose.isHidden = !self.isPresentView
        
        if let title = self.viewTitle {
            self.lblNVTitle.text = title
        }
        self.wsGetAddFriends()
    }
    
    //MARK:- Action
    
    @IBAction func btnCreateGroup_touchUpInside(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as? CreateGroupVC {
            vc.arrAllFriends = self.arrFriends
            vc.addFriendsVC = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnClose_touchUpInside(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnBack_touchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Function
    
    func reArrangeUserFriend(isBackGround:Bool = false, _ complition: (() -> ())? = nil ) {
        
        self.arrReceiveRequestFriends.removeAll()
        self.arrPendingRequestFriends.removeAll()
        self.arrAddNewFriends.removeAll()
        self.arrFriends.removeAll()
        
        for user in self.arrAllUserFriends {
            
            let first = self.arrSenderRequest.contains(where: { $0.receiver == user.uId && $0.acceptRequest == "1" })
            let second = self.arrReceiverRequest.contains(where: {  $0.sender == user.uId  && $0.acceptRequest == "1" })
            
            if self.arrReceiverRequest.contains(where: { $0.sender == user.uId && $0.acceptRequest == "0" }) {
                self.arrReceiveRequestFriends.append(user)
            }else if self.arrSenderRequest.contains(where: { $0.receiver == user.uId && $0.acceptRequest == "0" }) {
                self.arrPendingRequestFriends.append(user)
            }else if  first == true || second == true {
                self.arrFriends.append(user)
            }else {
                self.arrAddNewFriends.append(user)
            }
        }
        
        if isBackGround == false {
            self.tvAddFriends.reloadData()
        }
        
        if let complition = complition {
            complition()
        }
    }
    
    //MARK:- Web Service
    
    func wsJoinSenderRequest(complition: @escaping () -> ()) {
        let uIdSender = UserFetch.getSIData().uId
        let fetchJoinSenderRequest = DataReference.child(FBChild.joinFriendsRequest.isNothing()).queryOrdered(byChild: K.SENDER).queryEqual(toValue: uIdSender)
        fetchJoinSenderRequest.observe(.value) { (ref) in
            DispatchQueue.main.async {
                if let arrSender = ref.value as? NSDictionary, let arrSenderValue = arrSender.allValues as? [NSDictionary] {
                    self.arrSenderRequest = arrSenderValue.map({ JoinRequest($0) })
                }else {
                    self.arrSenderRequest.removeAll()
                }
                complition()
            }
        }
    }
    
    func wsJoinReceiverRequest(complition: @escaping () -> ()) {
        let uIdReceiver = UserFetch.getSIData().uId
        let fetchJoinSenderRequest = DataReference.child(FBChild.joinFriendsRequest.isNothing()).queryOrdered(byChild: K.RECEIVER).queryEqual(toValue: uIdReceiver)
        fetchJoinSenderRequest.observe(.value) { (ref) in
            DispatchQueue.main.async {
                if let arrReceiver = ref.value as? NSDictionary, let arrReceiverValue = arrReceiver.allValues as? [NSDictionary] {
                    self.arrReceiverRequest = arrReceiverValue.map({ JoinRequest($0) })
                }else {
                    self.arrReceiverRequest.removeAll()
                }
                complition()
            }
        }
    }
    
    func wsGetAddFriends(isBackGround:Bool = false,  _ complition: (() -> ())? = nil ) {
        if isBackGround == false {
            ActivityClick.startLoadingBar()
        }
        self.wsJoinSenderRequest {
            self.wsJoinReceiverRequest {
                DataReference.child(FBChild.register.isNothing()).observe(.value) { (ref) in
                    
                    if isBackGround == false {
                        ActivityClick.stopLoadingBar()
                    }
                    
                    if let users = ref.value as? NSDictionary {
                        if let arrUser = users.allValues as? [NSDictionary] {
                            self.arrAllUserFriends = arrUser.map({ User($0) }).filter({ $0.uId != UserFetch.getSIData().uId })
                        }else {
                            self.arrAllUserFriends.removeAll()
                        }
                    }else {
                        self.arrAllUserFriends.removeAll()
                    }
                    
                    self.reArrangeUserFriend(isBackGround: isBackGround) {
                        if let complition = complition {
                            complition()
                        }
                    }
                }
            }
        }
    }
}



//MARK:- Extension

extension AddFriendsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isShowOnlyFriends == true {
            return UIView()
        }else {
            let headerView = Bundle.main.loadNibNamed("HeaderViewTVCell", owner: nil, options: nil)?.first as? HeaderViewTVCell
            if section == 0 {
                headerView?.lblTitle.text = "Add Friends?"
            }else if section == 1 {
                headerView?.lblTitle.text = "Pending Request."
            }else if section == 2 {
                headerView?.lblTitle.text = "Add New Friends"
            }
            headerView?.imgViewRight.isHidden = true
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isShowOnlyFriends == true {
            return 0
        }else {
            if self.arrReceiveRequestFriends.count == 0 && section == 0 {
                return 0
            }else if self.arrPendingRequestFriends.count == 0 && section == 1 {
                return 0
            }else if self.arrAddNewFriends.count == 0 && section == 2{
              return 0
            }
            return 50
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isShowOnlyFriends == true {
            return 1
        }else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isShowOnlyFriends == true {
            return self.arrFriends.count
        }else {
            if section == 0 {
                return self.arrReceiveRequestFriends.count
            }else if section == 1 {
                return self.arrPendingRequestFriends.count
            }else if section == 2 {
                return self.arrAddNewFriends.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tvAddFriends.dequeueReusableCell(withIdentifier: "AddFriendsTVCell") as! AddFriendsTVCell
        if self.isShowOnlyFriends == true {
            let user = self.arrFriends[indexPath.row]
            cell.user = user
        }else {
            if indexPath.section == 0 {
                let user = self.arrReceiveRequestFriends[indexPath.row]
                cell.user = user
            }else if indexPath.section == 1 {
                let user = self.arrPendingRequestFriends[indexPath.row]
                cell.user = user
            }else if indexPath.section == 2 {
                let user = self.arrAddNewFriends[indexPath.row]
                cell.user = user
            }
        }
        cell.indexPath = indexPath
        cell.parent = self
        return cell
    }
    
    @objc func btnJoin_touchUpInside(sender:UIButton) {
        let indexPath = sender.tag.findIndexPath()
        let index = indexPath.row
        if  indexPath.section == 2 {
            let uIdSender = UserFetch.getSIData().uId
            let uIdReceiver = self.arrAddNewFriends[index].uId
            let joinId = UserSet.makeUIDCombination(firstId: uIdSender, secondId: uIdReceiver)
            
            let param = [K.SENDER : uIdSender,
                         K.RECEIVER : uIdReceiver,
                         K.ACCEPT_REQUEST : "0",
                         K.JOIN_FRIENDS_REQUEST_ID : joinId]
            
            DataReference.child(FBChild.joinFriendsRequest.isNothing()).child(joinId.isNothing()).setValue(param)
        }
    }
    
    @objc func btnAccept_touchUpInside(sender:UIButton) {
        let indexPath = sender.tag.findIndexPath()
        let index = indexPath.row
        if  indexPath.section == 0 {
            let uIdSender = UserFetch.getSIData().uId
            let uIdReceiver = self.arrReceiveRequestFriends[index].uId
            let joinId = UserSet.makeUIDCombination(firstId: uIdSender, secondId: uIdReceiver)
            
            DataReference.child(FBChild.joinFriendsRequest.isNothing()).child(joinId.isNothing()).updateChildValues([K.ACCEPT_REQUEST : "1"])
        }
    }
    
    @objc func btnCancel_touchUpInside(sender:UIButton) {
        DispatchQueue.main.async {
            let indexPath = sender.tag.findIndexPath()
            let index = indexPath.row
            let uIdSender = UserFetch.getSIData().uId
            var uIdReceiver = ""
            if self.isShowOnlyFriends == true {
                if indexPath.section == 0 {
                    uIdReceiver = self.arrFriends[index].uId
                }
            }else {
                if indexPath.section == 0 {
                    uIdReceiver = self.arrReceiveRequestFriends[index].uId
                }else if indexPath.section == 1 {
                    uIdReceiver = self.arrPendingRequestFriends[index].uId
                }
            }
            let joinId = UserSet.makeUIDCombination(firstId: uIdSender, secondId: uIdReceiver)
            DataReference.child(FBChild.joinFriendsRequest.isNothing()).child(joinId.isNothing()).removeValue()
            
            DataReference.child(FBChild.lastChatMessages.isNothing()).child(uIdSender.isNothing()).child(joinId.isNothing()).removeValue()
            DataReference.child(FBChild.lastChatMessages.isNothing()).child(uIdReceiver.isNothing()).child(joinId.isNothing()).removeValue()
        }
    }
    
    @objc func btnMessage_touchUpInside(sender:UIButton) {
        self.dismiss(animated: true) {
            if self.isShowOnlyFriends == true {
                let indexPath = sender.tag.findIndexPath()
                let index = indexPath.row
                if indexPath.section == 0 {
                    self.delegate?.userSelectedDetails(user: self.arrFriends[index])
                }
            }
        }
    }
}


