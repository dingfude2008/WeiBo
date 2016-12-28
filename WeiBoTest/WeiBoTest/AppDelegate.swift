//
//  AppDelegate.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    lazy var isSupportLandscape : Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .carPlay, .badge]) { (success, error) in
                print(success ? "授权成功" : "授权失败" )
            }
        } else {
            
            let notifySetting = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            
            application.registerUserNotificationSettings(notifySetting)
        }
        
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








