//
//  AppDelegate.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    lazy var isSupportLandscape : Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        setupAdditions()
        
        
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = DFMainViewController()
        window?.makeKeyAndVisible()
        
        loadInfo()
        
        return true
    }

    
    
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return isSupportLandscape ?  .landscape :  .portrait
    }
    
    
}


// MARK: - 设置应用额外的信息
extension AppDelegate {

    fileprivate func setupAdditions() {
    
        //1 设置 SVProgressHUD 最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
    
        //2 设置网络指示器
        
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        //3 设置用户授权显示通知
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .carPlay, .badge]) { (success, error) in
                print(success ? "授权成功" : "授权失败" )
            }
        } else {
            
            let notifySetting = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySetting)
        }
    }
    
}


extension AppDelegate {
    
    fileprivate func loadInfo(){
        
        DispatchQueue.global().async {
            
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            let data = NSData(contentsOf: url!)
            
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            
            let jsonPath = docDir.appending("/main.json")

            _ = data?.write(toFile: jsonPath, atomically: true)
            
//            print("保存json 结果\(result)，路径\(jsonPath)")
            
        }
        
    }
    
}








