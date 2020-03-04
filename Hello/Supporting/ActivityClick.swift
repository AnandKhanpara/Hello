//
//  ActiveTrack.swift
//  ChatInCoreData
//
//  Created by ZerOnes on 24/09/19.
//  Copyright © 2019 ZerOnes. All rights reserved.
//

import Foundation
import UIKit

class ActivityClick: NSObject {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let shared = ActivityClick()
    
    class func addAlert(Title: String? = "", Message: String? = "",type: AlertType)  {
        
        for view in ActivityClick.shared.appDelegate.window!.subviews {
            if view.isKind(of: CustomAlertView.self)  {
                view.removeFromSuperview()
            }
        }
        let alert = CustomAlertView(frame: ActivityClick.shared.appDelegate.window!.frame, Title: Title ?? "", Message: Message ?? "",type: type)
        ActivityClick.shared.appDelegate.window?.makeKeyAndVisible()
        ActivityClick.shared.appDelegate.window?.addSubview(alert)
    }
    
    class func startLoadingBar() {
        for view in ActivityClick.shared.appDelegate.window!.subviews {
            if view.isKind(of: CustomLodingBarView.self) {
                view.removeFromSuperview()
            }
        }
        let loading = CustomLodingBarView()
        loading.frame = ActivityClick.shared.appDelegate.window!.frame
        loading.center = ActivityClick.shared.appDelegate.window!.center
        ActivityClick.shared.appDelegate.window?.makeKeyAndVisible()
        ActivityClick.shared.appDelegate.window?.addSubview(loading)
    }
    
    class func stopLoadingBar() {
        for view in ActivityClick.shared.appDelegate.window!.subviews {
            if view.isKind(of: CustomLodingBarView.self) {
                view.removeFromSuperview()
            }
        }
    }
    
}
