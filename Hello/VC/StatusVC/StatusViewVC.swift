//
//  StatusViewVC.swift
//  Hello
//
//  Created by ZerOnes on 06/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class StatusViewVC: UIViewController {

    //MARK:- Outlet
    
    @IBOutlet weak var tvStatus: UITableView!
    
    //MARK:- Variable
    
    var arrUserStatus = [UserStatus]()
    var index = 0
    
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
        parentStatusViewVC = self
        self.tvStatus.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tvStatus.selectRow(at: IndexPath(row: self.index, section: 0), animated: false, scrollPosition: .middle)
        }
    }
    
    func viewWillSetUp() {
        
    }
    
    //MARK:- Action
    
    @IBAction func btnClose_touchUpInside(sender:UIButton) {
        print("click")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Function
    
    
    
    //MARK:- Web Service
    
}

//MARK:- Extension

extension StatusViewVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUserStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userStatus = self.arrUserStatus[indexPath.row]
        let cell = self.tvStatus.dequeueReusableCell(withIdentifier: "StatusViewTVCell", for: indexPath) as! StatusViewTVCell
        cell.userStatus = userStatus
        cell.cvStatus.reloadData()
        return cell
    }
}
