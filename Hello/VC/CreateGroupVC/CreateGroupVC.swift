//
//  CreateGroupVC.swift
//  Hello
//
//  Created by ZerOnes on 04/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {

    //MARK:- Outlet
    
    @IBOutlet weak var constraintViewMemberHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNVTitle: UILabel!
    @IBOutlet weak var txtFieldGroupName: UITextField!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var viewDone: UIView!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var viewMember: UIView!
    @IBOutlet weak var viewDeleteGroup: UIView!
    @IBOutlet weak var viewAddNewMember: UIView!
    @IBOutlet weak var viewTopDividerLine: UIView!
    @IBOutlet weak var viewTopDividerLineAddMember: UIView!
    @IBOutlet weak var viewTopDividerAddNewMembers: UIView!
    @IBOutlet weak var tvAddMember: UITableView!
    
    //MARK:- Variable
    
    var arrAllFriends = [User]()
    var arrAddFriends = [User]()
    var arrNewMember = [User]()
    var addFriendsVC:AddFriendsVC = AddFriendsVC()
    var isShowGroupDetails = false
    var isEditImage = false
    var isAddNewMember = false
    var group = Group()
    var dicGroupMember = [String:String]()
    var messageVC:MessageVC = MessageVC()
    
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
        self.tvAddMember.reloadData()
        self.viewTopDividerLine.addGradiantLayer(GradiantColor.redBlue)
        self.viewTopDividerLineAddMember.addGradiantLayer(GradiantColor.redBlue)
        self.viewTopDividerAddNewMembers.addGradiantLayer(GradiantColor.redBlue)
    }
    
    func viewWillSetUp() {
        
        self.arrAllFriends = AddFriendsVC.shared.arrFriends
        
        if self.isShowGroupDetails == true {
            self.constraintViewMemberHeight.constant = 50
            self.viewMember.isHidden = true
            self.viewTopDividerAddNewMembers.isHidden = false
            self.viewAddNewMember.isHidden = false
            self.lblNVTitle.text = self.group.groupDetails.groupName
            self.imgViewProfile.sd_setImage(with: self.group.groupDetails.groupImageLogoURL)
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 20
            self.txtFieldGroupName.text = self.group.groupDetails.groupName
            self.dicGroupMember = self.group.member as? [String:String] ?? [String:String]()
            self.tvAddMember.reloadData()
            self.viewDeleteGroup.isHidden = false
            if self.group.adminMembers[UserFetch.getSIData().uId] == nil {
                self.viewAddNewMember.alpha = 0.6
                self.viewAddNewMember.addBlank()
                self.txtFieldGroupName.isUserInteractionEnabled = false
                self.viewDeleteGroup.isHidden = true
                self.viewDone.isHidden = true
            }
        }else {
            self.constraintViewMemberHeight.constant = 0
            self.viewMember.isHidden = true
            self.viewAddNewMember.isHidden = true
            self.viewTopDividerAddNewMembers.isHidden = true
            self.viewDeleteGroup.isHidden = true
        }
    }
    
    //MARK:- Action
    
    @IBAction func txtFieldGroupName_editingChanged(_ sender: UITextField) {
        let groupnameLenght = 20
        let text = sender.text ?? ""
        if text.count <= groupnameLenght {
            self.txtFieldGroupName.text = sender.text
        }else {
            self.txtFieldGroupName.text = String(describing: text.prefix(20))
        }
    }
    
    @IBAction func btnAddGroupLogo_touchUpInside(_ sender: UIButton) {
        if (self.group.adminMembers[UserFetch.getSIData().uId] != nil && self.isShowGroupDetails == true) || self.isShowGroupDetails == false {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            let alert = UIAlertController(title: "Add Group Logo", message: "", preferredStyle: .actionSheet)
            let gallery = UIAlertAction(title: "Gallery", style: .default) { (_) in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
            let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
                picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) == true ? .camera : .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(camera)
            alert.addAction(gallery)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCreateGroupDone_touchUpInside(_ sender: UIButton) {
        
        let groupName = self.txtFieldGroupName.text ?? ""
        let imgLogo:UIImage? = self.imgViewProfile.image ?? nil
        let member = (self.dicGroupMember as NSDictionary).allKeys
        
        if imgLogo == nil {
            ActivityClick.addAlert(Title: "Add Group Logo", Message: "", type: .error)
        }else if groupName.isEmptyyy() == true {
            ActivityClick.addAlert(Title: "Enter Group Name", Message: "", type: .error)
        }else if (self.arrAddFriends.count <= 0 && self.isShowGroupDetails == false) || ( self.isShowGroupDetails == true && member.count <= 0) {
            ActivityClick.addAlert(Title: "Add Member", Message: "", type: .error)
        }else {
            if self.isShowGroupDetails == false {
                let groupId = UUID().uuidString
                self.wsCreateNewGroup(groupId: groupId, groupName: groupName, groupLogo: imgLogo ?? UIImage())
            }else {
                self.wsEditGroup(groupName: groupName, groupLogo: imgLogo ?? UIImage())
            }
            
        }
    }
    
    @IBAction func btnViewMember_touchUpInside(_ sender: UIButton) {
        self.viewMember.isHidden = true
        self.viewAddNewMember.isHidden = false
        self.isAddNewMember = false
        self.tvAddMember.reloadData()
    }
    
    @IBAction func btnAddNewMember_touchUpInside(_ sender: UIButton) {
        let arrFriendsFilter = self.arrAllFriends.filter({ self.dicGroupMember[$0.uId] == nil })
        self.arrNewMember = arrFriendsFilter
        self.viewMember.isHidden = false
        self.viewAddNewMember.isHidden = true
        self.isAddNewMember = true
        self.tvAddMember.reloadData()
    }
    
    @IBAction func btnDeleteGroup_touchUpInside(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Group", message: "Are you sure? \nDelete \(self.group.groupDetails.groupName) Group", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            let imgLogo:UIImage = self.imgViewProfile.image ?? UIImage()
            self.wsEditGroup(groupName: self.group.groupDetails.groupName, groupLogo: imgLogo, isDelete: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnClose_touchUpInside(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK:- Function

    
    //MARK:- Web Service
    
    func wsGroupLogoUploadInFirebaseStorage(name imageName:String, _ image:UIImage, complition: @escaping (String) -> ()) {
        
        guard let imageData = image.pngData() else { return }
        
        let storage = StorageReference.child(FBStorageChild.groupCreateLogoImage.isNothing()).child(imageName.isNothing())
        
        storage.putData(imageData, metadata: nil) { (metadata, error) in
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil, let url = url {
                        complition(String(describing: url))
                    }else {
                        ActivityClick.stopLoadingBar()
                        ActivityClick.addAlert(Title: "Something, went wrong", type: .error)
                    }
                }
                
            }else {
                ActivityClick.stopLoadingBar()
                ActivityClick.addAlert(Title: "Something, went wrong", type: .error)
            }
        }
    }
    
    func wsEditGroup(groupName:String, groupLogo image:UIImage, isDelete:Bool = false) {
        
        ActivityClick.startLoadingBar()
        
        let date = Date()
        let groupId = self.group.groupDetails.groupId
        let createdAt = date.gmtZeroTime()
        let imageName = groupId + "_" + date.timeString()
        
        var group = [String:Any]()
        var param = [K.GROUP_ID : groupId,
                     K.GROUP_NAME : groupName,
                     K.CREATEDAT : createdAt,
                     K.CHAT_TYPE : ChatType.group.type] as [String : Any]
        
        var lastMessage = [K.GROUP_ID : groupId,
                           K.GROUP_NAME : groupName,
                           K.CREATEDAT : createdAt,
                           K.SENDER : UserFetch.getSIData().uId,
                           K.MESSAGE_TYPE : MessageType.text.type,
                           K.CHAT_TYPE : ChatType.group.type,
                           K.MESSAGE_TEXT : "Group Updated by \(UserFetch.getSIData().userName)"]
        
        let groupAdminMembers = self.group.adminMembers
        
        if isDelete == true {
            var dicGroupMemberDelete = [String:String]()
            self.dicGroupMember.forEach { (key, _) in
                dicGroupMemberDelete[key] = "0"
            }
            self.dicGroupMember = dicGroupMemberDelete
            group = self.dicGroupMember
        }else {
            group = self.dicGroupMember
        }
        
        func createGroup(imageURL:String) {
            param[K.GROUP_IMAGE_LOGO] = imageURL
            lastMessage[K.GROUP_IMAGE_LOGO] = imageURL
            group[K.GROUP_DETAILS] = param
            group[K.GROUP_LAST_MESSAGE] = lastMessage
            group[K.GROUP_ADMIN_MEMBERS] = groupAdminMembers
            DataReference.child(FBChild.createGroupChat.isNothing()).child(groupId.isNothing()).setValue(group) { (error, ref) in
                ActivityClick.stopLoadingBar()
                if error == nil {
                    ActivityClick.addAlert(Title: "Successfully Update Group", Message: "", type: .success)
                    self.dismiss(animated: true) {
                        self.messageVC.navigationController?.popViewController(animated: true)
                    }
                }else {
                    ActivityClick.addAlert(Title: "Something, went wrong", Message: "", type: .error)
                }
            }
        }
        
        if self.isShowGroupDetails == true && self.isEditImage == false {
            createGroup(imageURL: self.group.groupDetails.groupImageLogo)
        }else if self.isShowGroupDetails == true && self.isEditImage == true {
            self.wsGroupLogoUploadInFirebaseStorage(name: imageName, image) { (imageURL) in
                createGroup(imageURL: imageURL)
            }
        }
    }
    
    func wsCreateNewGroup(groupId:String, groupName:String, groupLogo image:UIImage) {
        
        ActivityClick.startLoadingBar()
        
        var arrMember = [UserFetch.getSIData().uId]
        self.arrAddFriends.forEach({ arrMember.append($0.uId) })
        
        let date = Date()
        let createdAt = date.gmtZeroTime()
        let imageName = groupId + "_" + date.timeString()
        
        var group = [String:Any]()
        var param = [K.GROUP_ID : groupId,
                     K.GROUP_NAME : groupName,
                     K.CREATEDAT : createdAt,
                     K.CHAT_TYPE : ChatType.group.type] as [String : Any]
        
        var lastMessage = [K.GROUP_ID : groupId,
                           K.GROUP_NAME : groupName,
                           K.CREATEDAT : createdAt,
                           K.SENDER : UserFetch.getSIData().uId,
                           K.MESSAGE_TYPE : MessageType.text.type,
                           K.CHAT_TYPE : ChatType.group.type,
                           K.MESSAGE_TEXT : "Create New Group by \(UserFetch.getSIData().userName)"]
        
        let groupAdminMembers = [UserFetch.getSIData().uId : "1"]
        
        for member in arrMember {
            group[member] = "1"
        }
        
        self.wsGroupLogoUploadInFirebaseStorage(name: imageName, image) { (imageURL) in
            param[K.GROUP_IMAGE_LOGO] = imageURL
            lastMessage[K.GROUP_IMAGE_LOGO] = imageURL
            group[K.GROUP_DETAILS] = param
            group[K.GROUP_LAST_MESSAGE] = lastMessage
            group[K.GROUP_ADMIN_MEMBERS] = groupAdminMembers
            DataReference.child(FBChild.createGroupChat.isNothing()).child(groupId.isNothing()).setValue(group) { (error, ref) in
                ActivityClick.stopLoadingBar()
                if error == nil {
                    ActivityClick.addAlert(Title: "Successfully Created Group", Message: "", type: .success)
                    self.dismiss(animated: true) {
                         self.addFriendsVC.navigationController?.popViewController(animated: true)
                    }
                }else {
                    ActivityClick.addAlert(Title: "Something, went wrong", Message: "", type: .error)
                }
            }
        }
    }
    
}

//MARK:- Extension

extension CreateGroupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.isEditImage = true
                self.imgViewProfile.image = image.resize(image.size, base: 200)
            }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.isEditImage = true
                self.imgViewProfile.image = image.resize(image.size, base: 200)
            }
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 20
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isShowGroupDetails == true && self.isAddNewMember == false {
            return (self.dicGroupMember as NSDictionary).allKeys.count
        }else if self.isShowGroupDetails == true && self.isAddNewMember == true {
            return self.arrNewMember.count
        }else {
            return self.arrAllFriends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isShowGroupDetails == true && self.isAddNewMember == false {
            let cell = self.tvAddMember.dequeueReusableCell(withIdentifier: "EditMemberTVCell") as! EditMemberTVCell
            let userId = (self.dicGroupMember as NSDictionary).allKeys[indexPath.row] as? String ?? ""
            DataReference.child(FBChild.register.isNothing()).child(userId.isNothing()).observeSingleEvent(of: .value) { (ref) in
                if let ref = ref.value as? NSDictionary {
                    let dic = ["userDetails" : ref, "admins" : self.group.adminMembers]
                    cell.userDetails = dic as NSDictionary
                }
            }
            cell.indexPath = indexPath
            cell.parent = self
            return cell
        }else if self.isShowGroupDetails == true && self.isAddNewMember == true {
            let cell = self.tvAddMember.dequeueReusableCell(withIdentifier: "NewMemberTVCell") as! NewMemberTVCell
            let user = self.arrNewMember[indexPath.row]
            cell.user = user
            cell.indexPath = indexPath
            cell.parent = self
            return cell
        }else {
            let cell = self.tvAddMember.dequeueReusableCell(withIdentifier: "AddMemberTVCell") as! AddMemberTVCell
            let user = self.arrAllFriends[indexPath.row]
            cell.user = user
            cell.indexPath = indexPath
            cell.parent = self
            return cell
        }
    }
    
    @objc func btnAdd_touchUpInside(sender:UIButton) {
        let index = sender.tag % 10000000
        self.arrAddFriends.append(self.arrAllFriends[index])
        self.tvAddMember.reloadData()
    }
    
    @objc func btnRemove_touchUpInside(sender:UIButton) {
        let index = sender.tag % 10000000
        if let index = self.arrAddFriends.firstIndex(where: { $0.uId == self.arrAllFriends[index].uId }) {
            self.arrAddFriends.remove(at: index)
            self.tvAddMember.reloadData()
        }
    }
    
    @objc func btnRemoveAddMember_touchUpInside(sender:UIButton) {
        let index = sender.tag % 10000000
        let key = (self.dicGroupMember as NSDictionary).allKeys[index] as? String ?? ""
        self.dicGroupMember.removeValue(forKey: key)
        self.tvAddMember.reloadData()
    }
    
    @objc func btnNewMember_touchUpInside(sender:UIButton) {
        let index = sender.tag % 10000000
        let newMember = self.arrNewMember[index]
        self.dicGroupMember[newMember.uId] = "1"
        self.arrNewMember.remove(at: index)
        self.tvAddMember.reloadData()
    }
}
















































































































                                                                            /*
                                                                             Andy: Hello Smith, how are you, it's been a long time since we last met?
                                                                             
                                                                             Smith: Oh, hi Andy I'm have got a new job now and is going great. How about you?
                                                                             
                                                                             Andy: Not too bad.
                                                                             
                                                                             Smith: How often do you eat at this cafe?
                                                                             
                                                                             Andy: This is my first time my friends kept telling me the food was great, so tonight I decided to try it. What have you been up to?
                                                                             
                                                                             Smith: I have been so busy with my new job that I have not had the time to do much else, but otherwise, me and the family are all fine.
                                                                             
                                                                             Andy: Well, I hope you and your family have a lovely meal.
                                                                             
                                                                             Smith: Yes you too.
                                                                             */













