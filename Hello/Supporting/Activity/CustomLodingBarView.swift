//
//  LodingBarView.swift
//  ChatInCoreData
//
//  Created by ZerOnes on 23/09/19.
//  Copyright © 2019 ZerOnes. All rights reserved.
//

import Foundation
import UIKit


class CustomLodingBarView: UIView {
    
    var viewLoadingBG = UIView()
    var activityIndicator = UIActivityIndicatorView()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLoadingBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("fail")
    }
    
    func setUpLoadingBar() {
        
        self.backgroundColor = UIColor.clear
   
        let viewBG = UIView()
        viewBG.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        viewBG.layer.cornerRadius = 10
        viewBG.clipsToBounds = true
        self.addSubview(viewBG)
        viewBG.translatesAutoresizingMaskIntoConstraints = false
        viewBG.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        viewBG.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        viewBG.widthAnchor.constraint(equalToConstant: 150).isActive = true
        viewBG.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        viewBG.addSubview(self.activityIndicator)
        self.activityIndicator.style = .white
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: viewBG.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: viewBG.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 60 ).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.activityIndicator.startAnimating()
        
        let lblLoading = UILabel()
        lblLoading.text = "Loading..."
        lblLoading.textColor = UIColor.white
        lblLoading.font = UIFont(name: "CentraleSansRndBook", size: 16)
        lblLoading.textAlignment = NSTextAlignment.center
        viewBG.addSubview(lblLoading)
        lblLoading.translatesAutoresizingMaskIntoConstraints = false
        lblLoading.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: 10).isActive = true
        lblLoading.leadingAnchor.constraint(equalTo: viewBG.leadingAnchor, constant: 10).isActive = true
        lblLoading.trailingAnchor.constraint(equalTo: viewBG.trailingAnchor, constant: -10).isActive = true
        lblLoading.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    
//    func setUpLoadingBar() {
//
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//
//
//        self.addSubview(viewLoadingBG)
//        self.viewLoadingBG.layer.cornerRadius = 10
//        self.viewLoadingBG.clipsToBounds = true
//        self.viewLoadingBG.backgroundColor = .white
//        self.viewLoadingBG.translatesAutoresizingMaskIntoConstraints = false
//        self.viewLoadingBG.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.viewLoadingBG.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        self.viewLoadingBG.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        self.viewLoadingBG.heightAnchor.constraint(equalToConstant: 150).isActive = true
//
//        self.viewLoadingBG.addSubview(self.activityIndicator)
//        self.activityIndicator.style = .gray
//        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        self.activityIndicator.widthAnchor.constraint(equalToConstant: 60 ).isActive = true
//        self.activityIndicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
//        self.activityIndicator.startAnimating()
//    }
}
