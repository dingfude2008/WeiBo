//
//  DFMainViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit
import SVProgressHUD

class DFMainViewController: UITabBarController {

    
    /// 定时器
    fileprivate var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpClildControllers()
        
        setupComposeButton()
        
        setupTimer()
        
        setupNewFeature()

        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WeiBoTestUserShouldLoginNotification), object: nil)
        
        
    }
    
    
    
    deinit {
        timer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    @objc fileprivate func userLogin(n: Notification){
        
        print(#function)
        
        var when = DispatchTime.now()
        
        // token 过期
        if n.object != nil {
        
            // 渐变
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登陆已过期，请重新登陆")
            
            when = DispatchTime.now() + 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            let nav = UINavigationController(rootViewController: DFOAuthViewController())
            
            // modal 模态控制器，通常和UINavitionContrller 一起用
            self.present(nav, animated: true, completion: nil)
            
        }
        
        

        
    }
    
    
    
    @objc fileprivate func testBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc fileprivate func composeStatus(){
        
        print("撰写微博")
        
        let view = DFComposeTypeView.composeTypeView()
        
        // 循环引用
        view.show { [weak view] (clsName) in
            
            guard let clsName = clsName,
                let cls = NSClassFromString(Bundle.main.namespace + "." +  clsName) as? UIViewController.Type  else {
                view?.removeFromSuperview()
                return
            }
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            
            self.present(nav, animated: true, completion: {
                
                view?.removeFromSuperview()
            })
        }
        
        
//        let v = DFOAuthViewController()
//        
////        v.view.backgroundColor = UIColor.white
//        
//        // 这里不适用自己封装的，自己封装的把默认的tarbar隐藏掉了
//        let nav = UINavigationController(rootViewController: v)
//        
//        nav.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(testBack), isBack: true)
//        
//        present(nav, animated: true, completion: nil)
        
    }
    
    fileprivate lazy var composeButton : UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add`", backgroundImageName: "tabbar_compose_button")
    
}


// MARK: - UITabBarControllerDelegate
extension DFMainViewController : UITabBarControllerDelegate {

    
    /// 将要跳转控制器
    ///
    /// - Parameters:
    ///   - tabBarController: self
    ///   - viewController: 目标控制器
    /// - Returns: 是否跳转
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let nav = childViewControllers[0] as! DFNavigationViewController
        
        if nav.isEqual(viewController) && selectedIndex == 0 {
            
            let vc = nav.viewControllers[0] as! DFBaseViewController
            
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.45, execute: { 
                
                vc.loadData()
            })
            
            vc.tabBarItem.badgeValue = nil
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        }
        
        
        return !viewController.isMember(of: UIViewController.self)
    }
    
}


// MARK: - 设置新特性界面
extension DFMainViewController {

    fileprivate func setupNewFeature() {
    
        // 0. 判断是否登录
        if !DFNetwokrManager.shared.userLogon {
            return
        }
        
        // 1. 添加新特性
        // let frame = view.bounds
        let v = isNewVersion ? DFNewFeatureView.newFeatureView() : DFWelecomView.welecomView()
        
        view.addSubview(v)
    }
    /**
     版本号
     - 在 AppStore 每次升级应用程序，版本号都需要增加，不能递减
     
     - 组成 主版本号.次版本号.修订版本号
     - 主版本号：意味着大的修改，使用者也需要做大的适应
     - 次版本号：意味着小的修改，某些函数和方法的使用或者参数有变化
     - 修订版本号：框架／程序内部 bug 的修订，不会对使用者造成任何的影响
     */
    fileprivate var isNewVersion : Bool {
        
        // 比较当前版本和沙盒中的版本
        let currentVersion : String = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String) ?? ""
        
        print("当前版本号:\(currentVersion)")
        
        let path : String = ("version" as NSString).cz_appendDocumentDir()
        
        let sandBoxVersion : String = (try? String(contentsOfFile: path)) ?? ""
        
        print("沙盒版本:\(sandBoxVersion), 地址：path：\(path)")
        
        // 写入沙盒
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        // TEST
        return currentVersion != sandBoxVersion
//        return true
    }

}


// MARK: - 定时器相关方法
extension DFMainViewController {
    
    fileprivate func setupTimer(){
    
        timer = Timer.scheduledTimer(timeInterval: 28.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    /// 定时更新方法
    @objc fileprivate func updateTime(){
        
        if !DFNetwokrManager.shared.userLogon {
            return
        }
        
        DFNetwokrManager.shared.unreadCount { (unread) in
            
            
            self.tabBar.items?[0].badgeValue = unread > 0 ? "\(unread)" : nil
            
            
            UIApplication.shared.applicationIconBadgeNumber = unread
            
        }
        
    }
}


extension DFMainViewController {
    
    
    fileprivate func setupComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        let count = CGFloat(childViewControllers.count)
        
        
        /// 这里-1，是为了让中间的按钮更大一点，防止点进空白的控制器
        //  不-1的话，可以在tabar 的代理方法中判断，如果是UIViewController的实例，就不跳转
        let w = tabBar.bounds.width / count
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
        
    }
    
    
    /// 设置所有子控制器
    fileprivate func setUpClildControllers(){
        
        // 先从沙盒中获取上次已经下载的json，如果没有加载bundle中的
        let dicDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let jsonPath = (dicDir as String).appending("main.json")
        
        var data = NSData(contentsOfFile: jsonPath) as? Data
        
        if data == nil {
            
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            
            data = NSData(contentsOfFile: path!)  as? Data
        }
        
        guard let dataA = data,
            let arrayA = try? JSONSerialization.jsonObject(with: dataA,  options: []) as? [[String : AnyObject]],
            let array = arrayA else {
            return
        }
        
        
        var arrayM = [UIViewController]()
        
        for dict in array {
            
            arrayM.append(controller(dict: dict))
            
        }
        
        
//        let dataQ = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
//        
//        
//        let isOK =  (dataQ as NSData).write(toFile: "/Users/dingfude/Desktop/demo.json", atomically: true)
//        
//        
//        print(isOK)
        
//        let isOK = dataQ.write(toFile: "/Users/dingfude/Desktop/demo.plist", atomically: true)
        
        
        viewControllers = arrayM
        
    }
    
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典 [clsName, titile, imageName]
    /// - Returns: 子控制器
    fileprivate func controller(dict: [String : AnyObject]) -> UIViewController {
        
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? DFBaseViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String: String]
        else {
            return UIViewController()
        }
        
        let vc = cls.init()
        
        vc.visitorInfoDictionary = visitorDict
        
        vc.title = title
        
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .selected)
        
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12
            )], for: UIControlState(rawValue: 0))
        
        
        let nav = DFNavigationViewController(rootViewController: vc)
        
        return nav
        
    }
    
}















