//
//  AppDelegate.swift
//  Hello
//
//  Created by ZerOnes on 10/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setUserProperty("true", forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
        self.determineIsLogin()
        return true
    }
    
    //com.travel.fiji.guide
    
    //MARK:- Check Is Login
    
    func determineIsLogin() {
        var viewController:UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if UserFetch.getSIStatus() == true {
            viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        }else {
            viewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainVC
        }
        guard let vc = viewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationController?.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func signOut() {
        DispatchQueue.main.async {
            UserStandard.dictionaryRepresentation().keys.forEach { (key) in
                UserStandard.removeObject(forKey: key)
                UserStandard.synchronize()
            }
            self.determineIsLogin()
        }
    }
}










////MARK:- Outlet
//
////MARK:- Variable
//
////MARK:- View Life Cycle
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    self.viewDidSetUp()
//}
//
//override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    self.viewWillSetUp()
//}
//
////MARK:- View SetUp
//
//func viewDidSetUp() {}
//
//func viewWillSetUp() {}
//
////MARK:- Action
//
////MARK:- Function
//
////MARK:- Web Service
//
//}
//
////MARK:- Extension
