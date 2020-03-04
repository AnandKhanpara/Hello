//
//  UserStatusTVCell.swift
//  Hello
//
//  Created by ZerOnes on 07/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit

class UserStatusTVCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var cvUserStatus: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cvUserStatus.delegate = self
        self.cvUserStatus.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentHomeVC.arrUsersStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let status = parentHomeVC.arrUsersStatus[indexPath.row]
        let cell = self.cvUserStatus.dequeueReusableCell(withReuseIdentifier: "UserStatusCVCell", for: indexPath) as! UserStatusCVCell
        cell.userStatus = status
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 160)
    }
    
    
}
