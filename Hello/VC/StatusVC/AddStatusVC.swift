//
//  AddStatusVC.swift
//  Hello
//
//  Created by ZerOnes on 12/03/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class AddStatusVC: UIViewController {
    
    //MARK:- Outlet
    
    //MARK:- Variable
    
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
    }
    
    func viewWillSetUp() {
        
    }
    
    //MARK:- Action
    
    //MARK:- Function
    
    //MARK:- Web Service
    
}

//MARK:- Extension
