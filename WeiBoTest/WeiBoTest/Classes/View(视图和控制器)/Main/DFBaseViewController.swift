//
//  DFBaseViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit


// 利用 extension 把方法分类，便于阅读和维护
// extension 不能有属性
// extension 中不能重写父类方法。重写是子类的职责，扩展是对类的扩展

/// 所有主控制器的基类控制器
class DFBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var tableView : UITableView?
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x:0, y:0, width:UIScreen.cz_screenWidth(), height:64))
    
    lazy var navItem = UINavigationItem()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
     
        loadData()
        
    }
    
    
    
    /// 使用代码控制设备方向
    /*
        portrait    竖屏  （肖像）
        landscape   横屏  （风向）
     
        视频是通过 modal 模态展现的
     
     */
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    
    override var interfaceOrientation:UIInterfaceOrientation {
    
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        
        return .portrait
    }
    
    
    override var title: String? {
        
        didSet{
        
            navItem.title = title
            
        }
        
    }
    
    
    // 准备空的数据源方法
    func loadData() {
    
    }
    
    

}

// MARK: - UI界面设计
extension DFBaseViewController {
    
    func setupUI(){
        
        view.backgroundColor = UIColor.cz_random()
        
        // UINavigationController  + TableView 默认会启动自动缩进，需要改回 fasle
        automaticallyAdjustsScrollViewInsets = false
        
        self.setupNavigationBar()
        
        self.setupTableView()
    }
    
    fileprivate func setupNavigationBar(){
        
        view.addSubview(navigationBar)
        
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        
        navigationBar.items = [navItem]
    }
    
    fileprivate func setupTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        tableView?.dataSource = self
        
        tableView?.delegate = self
        
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
    }

}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension DFBaseViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    // 基类只是准备方法，子类负责具体的实现
    // 子类的数据方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    
}





