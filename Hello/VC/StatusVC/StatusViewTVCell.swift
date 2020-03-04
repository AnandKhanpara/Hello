//
//  StatusViewTVCell.swift
//  Hello
//
//  Created by ZerOnes on 07/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import SDWebImage

class StatusViewTVCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate   {
    
    
    @IBOutlet weak var constraintViewWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var cvStatus: UICollectionView!
    
    var stackViewProgressBarBackGround = UIStackView()
    var userStatus = UserStatus()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cvStatus.delegate = self
        self.cvStatus.dataSource = self
        self.constraintViewHeight.constant = UIApplication.shared.windows.first?.frame.size.height ?? 0
        self.constraintViewWidth.constant = UIApplication.shared.windows.first?.frame.size.width ?? 0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userStatus.arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.cvStatus.dequeueReusableCell(withReuseIdentifier: "StatusCVCell", for: indexPath) as! StatusCVCell
        cell.userStatus = self.userStatus
        cell.status = self.userStatus.arrStatus[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cvStatus.frame.size
    }
    
}


