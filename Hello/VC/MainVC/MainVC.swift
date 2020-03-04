//
//  MainVC.swift
//  Hello
//
//  Created by ZerOnes on 10/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var viewBGSignUp: UIView!
    @IBOutlet weak var viewBGSignInChangeStatus: UIView!
    @IBOutlet weak var viewBGSignUpChangeStatus: UIView!
    @IBOutlet weak var viewBGSignIn: UIView!
    @IBOutlet weak var viewAppName: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    
    //MARK:- Variable
    
    var status:Status = .signIn
    var isSuccess = false
    
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
        //self.txtFieldUsername.text = ""
        //self.txtFieldEmail.text = "@gmail.com"
        //self.txtFieldPassword.text = "123456"
        //self.txtFieldConfirmPassword.text = "123456"
        self.signUpInStatus(.signIn)
    }
    
    func viewWillSetUp() {
        
    }
    
    //MARK:- Action
    
    @IBAction func txtFieldUsername_editingChanged(_ sender: UITextField) {
        let usernameLenght = 20
        let text = sender.text ?? ""
        if text.count <= usernameLenght {
            self.txtFieldUsername.text = sender.text
        }else {
            self.txtFieldUsername.text = String(describing: text.prefix(20))
        }
    }
    
    @IBAction func btnAddProfile_touchUpInside(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController(title: "Select Profile", message: "", preferredStyle: .actionSheet)
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
    
    @IBAction func btnSignUpChangeStatus_touchUpInside(_ sender: UIButton) {
        self.signUpInStatus(.signUp)
    }
    
    @IBAction func btnSignInChangeStatus_touchUpInside(_ sender: UIButton) {
        self.signUpInStatus(.signIn)
    }
    
    @IBAction func btnSignUp_touchUpInside(_ sender: UIButton) {
        let username = self.txtFieldUsername.text ?? ""
        let email = self.txtFieldEmail.text ?? ""
        let password = self.txtFieldPassword.text ?? ""
        let confirm = self.txtFieldConfirmPassword.text ?? ""
        let image = self.imgViewProfile.image
        
        if image == nil {
            ActivityClick.addAlert(Title: "Select profile", type: .error)
        }else if username == "" || username.trimmingCharacters(in: .whitespaces) == "" {
            ActivityClick.addAlert(Title: "Enter username", type: .error)
        }else if email == "" || email.trimmingCharacters(in: .whitespaces) == "" {
            ActivityClick.addAlert(Title: "Enter email", type: .error)
        }else if email.isValidEmail() == false {
            ActivityClick.addAlert(Title: "Enter valid email", type: .error)
        }else if password == "" || password.trimmingCharacters(in: .whitespaces) == "" {
            ActivityClick.addAlert(Title: "Enter password", type: .error)
        }else if password.count > 6 {
            ActivityClick.addAlert(Title: "Enter password equal & more than six charactor", type: .error)
        }else if confirm == "" || confirm.trimmingCharacters(in: .whitespaces) == "" {
            ActivityClick.addAlert(Title: "Enter confirm password", type: .error)
        }else if confirm != password {
            ActivityClick.addAlert(Title: "Enter confirm password not equal password", type: .error)
        }else{
            guard let image = image else { return }
            let uId = UUID().uuidString
            self.wsSignUp(uId: uId, userName: username, email: email, password: password, image: image)
        }
    }
    
    @IBAction func btnSignIn_touchUpInside(_ sender: UIButton) {
        let email = self.txtFieldEmail.text ?? ""
        let password = self.txtFieldPassword.text ?? ""
        
        if email == "" || email.trimmingCharacters(in: .whitespaces) == "" {
            ActivityClick.addAlert(Title: "Enter email", type: .error)
        }else if email.isValidEmail() == false {
            ActivityClick.addAlert(Title: "Enter valid email", type: .error)
        }else if password == "" || password.trimmingCharacters(in: .whitespaces) == "" {
            ActivityClick.addAlert(Title: "Enter password", type: .error)
        }else {
            self.wsSignIn(email: email, password: password)
        }
    }
    
    
    //MARK:- Function
    
    fileprivate func signUpInStatus(_ status:Status) {
        self.status = status
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.viewImage.isHidden = status == .signUp ? false : true
            self.viewImage.alpha = status == .signUp ? 1 : 0
            self.viewAppName.isHidden = status == .signUp ? true : false
            self.viewAppName.alpha = status == .signUp ? 0 : 1
            self.viewBGSignInChangeStatus.isHidden = status == .signUp ? false : true
            self.viewBGSignInChangeStatus.alpha = status == .signUp ? 1 : 0
            self.viewBGSignUpChangeStatus.isHidden = status == .signUp ? true : false
            self.viewBGSignUpChangeStatus.alpha = status == .signUp ? 0 : 1
            self.viewBGSignUp.isHidden = status == .signUp ? false : true
            self.viewBGSignUp.alpha = status == .signUp ? 1 : 0
            self.viewBGSignIn.isHidden = status == .signUp ? true : false
            self.viewBGSignIn.alpha = status == .signUp ? 0 : 1
            self.txtFieldUsername.isHidden = status == .signUp ? false : true
            self.txtFieldUsername.alpha = status == .signUp ? 1 : 0
            self.txtFieldConfirmPassword.isHidden = status == .signUp ? false : true
            self.txtFieldConfirmPassword.alpha = status == .signUp ? 1 : 0
            self.view.layoutIfNeeded()
        })
    }
    
    //75DA0118-634F-44E5-91A8-6CBC29A11C04
    //91A39C57-F072-4397-9FA4-E05C5AD071AB
    
    //MARK:- Web Service
    
    func wsCheckUserEmailAlreadyRegisterd(email:String, complition: @escaping () -> ()) {
        let findEmail = DataReference.child(FBChild.register.isNothing()).queryOrdered(byChild: K.EMAIL).queryEqual(toValue: email)
        findEmail.observe(.value, with: { (ref) in
            if let _ = ref.value as? NSDictionary {
                ActivityClick.stopLoadingBar()
                if self.isSuccess == false {
                    ActivityClick.addAlert(Title: "Email is already taken.", type: .error)
                }
            }else {
                self.isSuccess = true
                complition()
            }
        }) { (error) in
            ActivityClick.stopLoadingBar()
            ActivityClick.addAlert(Title: "Something, went wrong", type: .error)
        }
    }
    
    func wsSignUpProfileUploadInFirebaseStorage(name imageName:String, _ image:UIImage, complition: @escaping (String) -> ()) {
        
        guard let imageData = image.pngData() else { return }
        
        let storage = StorageReference.child(FBStorageChild.registerUserProfileImage.isNothing()).child(imageName.isNothing())
        
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
    
    func wsSignUp(uId:String, userName:String, email:String, password:String, image:UIImage) {
        
        self.isSuccess = false
        ActivityClick.startLoadingBar()
        
        let date = Date()
        let createdAt = date.gmtZeroTime()
        let imageName = "\(uId)_\(date.timeString())"
        
        var param = [K.EMAIL: email,
                     K.PASSWORD: password,
                     K.USERNAME: userName,
                     K.UID: uId,
                     K.CREATEDAT: createdAt]
        
        self.wsCheckUserEmailAlreadyRegisterd(email: email) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.wsSignUpProfileUploadInFirebaseStorage(name: imageName, image) { (path) in
                    param[K.PROFILE] = path
                    DataReference.child(FBChild.register.isNothing()).child(uId.isNothing()).setValue(param) { (error, dataRef) in
                        ActivityClick.stopLoadingBar()
                        if self.status == .signUp {
                            if error == nil {
                                self.signUpInStatus(.signIn)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    ActivityClick.addAlert(Title: "Successfully Registration.", type: .success)
                                }
                            }else {
                                ActivityClick.addAlert(Title: "Something, went wrong", type: .error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func wsSignIn(email:String, password:String) {
        
        ActivityClick.startLoadingBar()
        
        let findEmail = DataReference.child(FBChild.register.isNothing()).queryOrdered(byChild: K.EMAIL).queryEqual(toValue: email)
        findEmail.observe(.value) { (ref) in
            ActivityClick.stopLoadingBar()
            if self.status == .signIn {
                if let user = ref.value as? NSDictionary, let data = user.allValues.first as? NSDictionary {
                    let emailF = data[K.EMAIL] as? String ?? "nothing"
                    let passwordF = data[K.PASSWORD] as? String ?? "nothing"
                    if email == emailF && password == passwordF {
                        DispatchQueue.main.async {
                            UserFetch.setSIStatus(true)
                            UserFetch.setSIData(data)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                ActivityClick.addAlert(Title: "Successfully", type: .success)
                            }
                            App.determineIsLogin()
                        }
                    }else {
                        UserFetch.setSIStatus(false)
                        ActivityClick.addAlert(Title: "Something wrong email or password", type: .error)
                    }
                }else {
                    UserFetch.setSIStatus(false)
                    ActivityClick.addAlert(Title: "Enter email is not register.", type: .error)
                }
            }
        }
    }
}

//MARK:- Extension

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.imgViewProfile.image = image.resize(image.size, base: 200)
            }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.imgViewProfile.image = image.resize(image.size, base: 200)
            }
            self.imgViewProfile.clipsToBounds = true
            self.imgViewProfile.layer.cornerRadius = 20
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

