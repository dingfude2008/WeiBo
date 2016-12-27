//
//  DFMainViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpClildControllers()
        
        setupComposeButton()
        
        
//        DFNetwokrManager.shard.getUid { (uid) in
//            print("uid : \(uid)")
//            
//            
//        }
        
        DFNetwokrManager.shard.unreadCount { (unread) in
            
            print("未读微博 \(unread)条")
            
        }

    }
    
    
    @objc fileprivate func testBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc fileprivate func composeStatus(){
        
        print("撰写微博")
        
        let v = DFModalViewController()
        
        v.view.backgroundColor = UIColor.black
                
        let nav = DFNavigationViewController(rootViewController: v)
        
        nav.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(testBack), isBack: true)
        
        
        present(nav, animated: true, completion: nil)
        
    }
    
    fileprivate lazy var composeButton : UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add`", backgroundImageName: "tabbar_compose_button")
    
}


extension DFMainViewController {
    
    
    fileprivate func setupComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        let count = CGFloat(childViewControllers.count)
        
        let w = tabBar.bounds.width / count - 1
        
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















