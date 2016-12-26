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
// extension 中不能重写父类'本类'中方法。重写是子类的职责，扩展是对类的扩展
// 如果方法声明在extension中，是可以在重写的。

/// 所有主控制器的基类控制器
class DFBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    /// 登陆标记
    var userLogon = true
    
    // 访客信息字典
    var visitorInfoDictionary : [String : String]?
    
    var tableView : UITableView?
    
    var refreshControl : UIRefreshControl?
    
    var isPullup = false
    
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
        
        // 如果子类不实现任何方法，默认关闭上下拉刷新
        refreshControl?.endRefreshing()
    }
    
    

}


// MARK: - 事件
extension DFBaseViewController {

    func register(){
        print("register")
    }
    
    func login(){
        print("login")
    }
    
}


// MARK: - UI界面设计
extension DFBaseViewController {
    
    fileprivate func setupUI(){
        
        view.backgroundColor = UIColor.cz_random()
        
        // UINavigationController  + TableView 默认会启动自动缩进，需要改回 fasle
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        userLogon ? setupTableView() : setupVisitorView()
        
        
    }
    
    
    fileprivate func setupNavigationBar(){
        
        view.addSubview(navigationBar)
        
        // 设置这个bar的背景颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        
        navigationBar.items = [navItem]
        
        // 字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        
        // 设置系统按钮的文字颜色
        navigationBar.tintColor = UIColor.orange
        
        
        
        
    }
    
    func setupTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        tableView?.dataSource = self
        
        tableView?.delegate = self
        
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        
        refreshControl = UIRefreshControl()
        
        tableView?.addSubview(refreshControl!)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }
    
    
    fileprivate func setupVisitorView(){
        
        let visitorView = DFVisitorView(frame: view.bounds)
        
        visitorView.visitorInfo = visitorInfoDictionary
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))

        navItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: .plain, target: self, action: #selector(login))
        
        
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
    
    // 在显示最后一行的时候做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        let count = tableView.numberOfRows(inSection: section)
        
        if row == count - 1 && !isPullup {
        
            isPullup = true
            
            print("上拉刷新")
            
            loadData()
        }
        
        
    }
    
    
}





