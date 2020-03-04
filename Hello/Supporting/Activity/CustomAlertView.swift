//
//  AlertView.swift
//  ChatInCoreData
//
//  Created by ZerOnes on 17/09/19.
//  Copyright © 2019 ZerOnes. All rights reserved.
//

import Foundation
import UIKit

class CustomAlertView : UIView ,UIGestureRecognizerDelegate{
    
    var constraintHeight : NSLayoutConstraint!
    
    init(frame: CGRect,Title:String,Message:String,type:AlertType) {
        super.init(frame: frame)
        self.setUpView(Title:Title,Message:Message,type:type)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("error")
    }
    
    
    func setUpView(Title:String,Message:String,type:AlertType) {
        let appDele = UIApplication.shared.delegate as! AppDelegate
        
        let topSafe = appDele.window!.safeAreaInsets.top
        let heightV = topSafe + 80
        self.frame = CGRect(x: 0, y: 0, width: appDele.window!.frame.width, height: heightV)
        self.backgroundColor = UIColor.clear
    
        let rect = CGRect(x: 0, y: -heightV, width: self.frame.width, height: heightV)
        let viewAlterDetails = UIView(frame: rect)
        let success = UIColor(red: 43/255, green: 185/255, blue: 115/255, alpha: 1)
        let error = UIColor(red: 215/255, green: 40/255, blue: 40/255, alpha: 1)
        viewAlterDetails.backgroundColor = type == .success ? success : error
        viewAlterDetails.clipsToBounds = true
        viewAlterDetails.layer.cornerRadius = 10
        viewAlterDetails.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        let image = type == .success ? UIImage(named: "success") : UIImage(named: "error")
        let imageView = UIImageView(image: image )
        imageView.clipsToBounds = true
        
        //let safeView = UIView()
        //safeView.backgroundColor = .blue
        //safeView.frame = CGRect(x: 0, y: 0, width: appDele.window!.frame.width, height: topSafe)
        
        var lblTitle = UILabel()
        var lblMessage = UILabel()
        
        if Title != "" && Message == "" {
            imageView.layer.cornerRadius = 20
            imageView.frame = CGRect(x: 10, y: topSafe + 20, width: 40, height: 40)
            lblTitle.frame = CGRect(x: 40 + 20, y: topSafe + 5, width: appDele.window!.frame.width - 80, height: 70)
            lblMessage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }else if Title == "" && Message != ""{
            imageView.layer.cornerRadius = 20
            imageView.frame = CGRect(x: 10, y: topSafe + 20, width: 40, height: 40)
            lblTitle.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            lblMessage.frame = CGRect(x: 40 + 20, y: topSafe + 5, width: appDele.window!.frame.width - 80, height: 70)
        }else {
            imageView.layer.cornerRadius = 25
            imageView.frame = CGRect(x: 10, y: topSafe + 10, width: 50, height: 50)
            lblTitle = UILabel(frame: CGRect(x: 50 + 20, y: topSafe + 10, width: appDele.window!.frame.width - 80, height: 20))
            lblMessage = UILabel(frame: CGRect(x: 50 + 20, y: topSafe + 35, width: appDele.window!.frame.width - 80, height: 35))
        }
        
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        lblTitle.numberOfLines = 0
        lblTitle.text = Title
        lblTitle.textColor = .white
        lblTitle.font = UIFont(name: "CentraleSansRndBook", size: 16)
        lblTitle.contentMode = .left
        
        lblMessage.numberOfLines = 0
        lblMessage.text = Message
        lblMessage.textColor = .white
        lblMessage.font = UIFont(name: "CentraleSansRndBook", size: 14)
        
        //lblMessage.backgroundColor = .orange
        //lblTitle.backgroundColor = .yellow
        
        //print(lblTitle.text ?? "", lblMessage.text ?? "")
        
        self.addSubview(viewAlterDetails)
        viewAlterDetails.addSubview(lblTitle)
        viewAlterDetails.addSubview(lblMessage)
        viewAlterDetails.addSubview(imageView)
        //viewAlterDetails.addSubview(safeView)
        
        UIView.animate(withDuration: 0.3) {
            let rect1 = CGRect(x: 0, y: 0, width: self.frame.width, height: heightV)
            viewAlterDetails.frame = rect1
            appDele.window!.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3, animations: {
                let rect2 = CGRect(x:0, y: -heightV, width: self.frame.width, height: heightV)
                viewAlterDetails.frame = rect2
                appDele.window!.layoutIfNeeded()
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
}

public enum AlertType {
    case success
    case error
}













//class CustomAlertView : UIView ,UIGestureRecognizerDelegate{
//
//    var constraintHeight : NSLayoutConstraint!
//
//
//    init(frame: CGRect,Title:String,Message:String,type:AlertType) {
//        super.init(frame: frame)
//        self.setUpView(Title:Title,Message:Message,type:type)
//    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        print("error")
//    }
//
//
//    func setUpView(Title:String,Message:String,type:AlertType) {
//        let appDele = UIApplication.shared.delegate as! AppDelegate
//        let topSafe = appDele.window!.safeAreaInsets.top
//        let heightV = topSafe + 80
//        self.frame = CGRect(x: 0, y: 0, width: appDele.window!.frame.width, height: heightV)
//        self.backgroundColor = UIColor.clear
//
//        let rect = CGRect(x: 0, y: -heightV, width: self.frame.width, height: heightV)
//        let viewAlterDetails = UIView(frame: rect)
//        let success = UIColor(red: 43/255, green: 185/255, blue: 115/255, alpha: 1)
//        let error = UIColor(red: 215/255, green: 40/255, blue: 40/255, alpha: 1)
//        viewAlterDetails.backgroundColor = type == .success ? success : error
//        viewAlterDetails.clipsToBounds = true
//        viewAlterDetails.layer.cornerRadius = 10
//        viewAlterDetails.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
//
//        let image = type == .success ? UIImage(named: "success") : UIImage(named: "error")
//        let imageView = UIImageView(image: image )
//        imageView.clipsToBounds = true
//
//        //let safeView = UIView()
//        //safeView.backgroundColor = .blue
//        //safeView.frame = CGRect(x: 0, y: 0, width: appDele.window!.frame.width, height: topSafe)
//
//        var lblTitle = UILabel()
//        var lblMessage = UILabel()
//
//        if Title != "" && Message == "" {
//            imageView.layer.cornerRadius = 20
//            imageView.frame = CGRect(x: 10, y: topSafe + 20, width: 40, height: 40)
//            lblTitle.frame = CGRect(x: 40 + 20, y: topSafe + 5, width: appDele.window!.frame.width - 80, height: 70)
//            lblMessage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        }else if Title == "" && Message != ""{
//            imageView.layer.cornerRadius = 20
//            imageView.frame = CGRect(x: 10, y: topSafe + 20, width: 40, height: 40)
//            lblTitle.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//            lblMessage.frame = CGRect(x: 40 + 20, y: topSafe + 5, width: appDele.window!.frame.width - 80, height: 70)
//        }else {
//            imageView.layer.cornerRadius = 25
//            imageView.frame = CGRect(x: 10, y: topSafe + 10, width: 50, height: 50)
//            lblTitle = UILabel(frame: CGRect(x: 50 + 20, y: topSafe + 10, width: appDele.window!.frame.width - 80, height: 20))
//            lblMessage = UILabel(frame: CGRect(x: 50 + 20, y: topSafe + 35, width: appDele.window!.frame.width - 80, height: 35))
//        }
//
//        imageView.layer.borderColor = UIColor.white.cgColor
//        imageView.layer.borderWidth = 2
//
//        lblTitle.numberOfLines = 0
//        lblTitle.text = Title
//        lblTitle.textColor = .white
//        lblTitle.font = UIFont.boldSystemFont(ofSize: 18)
//        lblTitle.contentMode = .left
//
//        lblMessage.numberOfLines = 0
//        lblMessage.text = Message
//        lblMessage.textColor = .white
//        lblMessage.font = UIFont.systemFont(ofSize: 16)
//
//        //lblMessage.backgroundColor = .orange
//        //lblTitle.backgroundColor = .yellow
//
//        //print(lblTitle.text ?? "", lblMessage.text ?? "")
//
//        self.addSubview(viewAlterDetails)
//        viewAlterDetails.addSubview(lblTitle)
//        viewAlterDetails.addSubview(lblMessage)
//        viewAlterDetails.addSubview(imageView)
//        //viewAlterDetails.addSubview(safeView)
//
//        UIView.animate(withDuration: 0.3) {
//            let rect1 = CGRect(x: 0, y: 0, width: self.frame.width, height: heightV)
//            viewAlterDetails.frame = rect1
//            appDele.window!.layoutIfNeeded()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            UIView.animate(withDuration: 0.3, animations: {
//                let rect2 = CGRect(x:0, y: -heightV, width: self.frame.width, height: heightV)
//                viewAlterDetails.frame = rect2
//                appDele.window!.layoutIfNeeded()
//            }, completion: { (_) in
//                self.removeFromSuperview()
//            })
//        }
//    }
//}
//
//public enum AlertType {
//    case success
//    case error
//}
