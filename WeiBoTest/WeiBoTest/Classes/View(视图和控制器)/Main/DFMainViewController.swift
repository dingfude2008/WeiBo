//
//  DFMainViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFMainViewController: UITabBarController {

    
    /// 定时器
    fileprivate var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpClildControllers()
        
        setupComposeButton()
        
        setupTimer()

        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WeiBoTestUserLogin), object: nil)
        
        
    }
    
    
    
    deinit {
        timer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    @objc fileprivate func userLogin(n: Notification){
        
        print(#function)
        
        let nav = UINavigationController(rootViewController: DFOAuthViewController())
        
        // modal 模态控制器，通常和UINavitionContrller 一起用
        present(nav, animated: true, completion: nil)
        
    }
    
    
    
    @objc fileprivate func testBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc fileprivate func composeStatus(){
        
        print("撰写微博")
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
//        let idx = (childViewControllers as NSArray).index(of: viewController)
//        
//        if selectedIndex == 0 && selectedIndex == idx {
//            print("是第一个")
//        }
//    
//        
////        selectController
        
        
    }
    
    

}


// MARK: - 定时器相关方法
extension DFMainViewController {
    
    fileprivate func setupTimer(){
    
        timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
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















